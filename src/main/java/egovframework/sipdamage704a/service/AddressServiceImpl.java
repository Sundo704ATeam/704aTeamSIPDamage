package egovframework.sipdamage704a.service;

import org.locationtech.proj4j.CRSFactory;
import org.locationtech.proj4j.CoordinateReferenceSystem;
import org.locationtech.proj4j.CoordinateTransform;
import org.locationtech.proj4j.CoordinateTransformFactory;
import org.locationtech.proj4j.ProjCoordinate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.sipdamage704a.dto.address.AddressDto;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class AddressServiceImpl implements AddressService {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final String VWORLD_URL =
        "https://api.vworld.kr/req/address?service=address" +
        "&request=getAddress&version=2.0&crs=epsg:4326" +
        "&point={lon},{lat}&format=json&type=both&key={key}";

    @Value("469BE1D2-99C1-3245-8BDD-6AA1B4658915")
    private String apiKey;

    @Override
    public AddressDto getlonlatpoint(String x, String y) {
        CRSFactory crsFactory = new CRSFactory();
        CoordinateReferenceSystem srcCrs = crsFactory.createFromName("EPSG:3857");
        CoordinateReferenceSystem dstCrs = crsFactory.createFromName("EPSG:4326");

        CoordinateTransformFactory ctFactory = new CoordinateTransformFactory();
        CoordinateTransform transform = ctFactory.createTransform(srcCrs, dstCrs);

        double xVal = Double.parseDouble(x);
        double yVal = Double.parseDouble(y);

        ProjCoordinate srcCoord = new ProjCoordinate(xVal, yVal);
        ProjCoordinate dstCoord = new ProjCoordinate();
        transform.transform(srcCoord, dstCoord);

        
        
        AddressDto addressDto = new AddressDto(); 
        addressDto.setLon(String.valueOf(dstCoord.x));
        addressDto.setLat(String.valueOf(dstCoord.y));

        return addressDto;
    }

    @Override
    public AddressDto getAddressDetail(AddressDto addressDto) {
        String url = VWORLD_URL
                .replace("{key}", apiKey)
                .replace("{lon}", addressDto.getLon())
                .replace("{lat}", addressDto.getLat());

        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

        if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
            try {
                JsonNode root = objectMapper.readTree(response.getBody());
                JsonNode results = root.path("response").path("result");

                if (results.isArray() && results.size() > 0) {
                    String addressText = results.get(0).path("text").asText();
                    addressDto.setPointAddress(addressText);
                } else {
                    addressDto.setPointAddress("주소 없음");
                }

            } catch (Exception e) {
                throw new RuntimeException("주소 JSON 파싱 실패", e);
            }
            return addressDto;
        } else {
            throw new RuntimeException("주소 변환 실패: " + response.getStatusCode());
        }
    }
}