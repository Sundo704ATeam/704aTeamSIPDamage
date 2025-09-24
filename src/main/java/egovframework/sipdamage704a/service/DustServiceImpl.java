package egovframework.sipdamage704a.service;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.sipdamage704a.dao.DustDao;
import egovframework.sipdamage704a.dto.dust.DustDto;
import egovframework.sipdamage704a.dto.dust.DustForecastDto;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class DustServiceImpl implements DustService {

	private final DustDao dustDao;
	private final RestTemplate restTemplate;
	private final ObjectMapper objectMapper;

	@Value("${pm10.api.authKey}")
	private String serviceKey;

	@Value("${station.base}")
	private String stationBaseUrl;

	@Value("${pm10.api.base}")
	private String MeasureBaseUrl;
	
	@Value("${dustForecast.base}")
	private String forecastBaseUrl;
	
	private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	@Override
	public List<DustDto> getDustStation() { //모든 측정소
		System.out.println("DustServiceImpl getDustStation start");
		return dustDao.getDustStation();
	}

	/** 측정소 목록 조회 후 DB upsert */
	public void fetchDustStations() { //측정소 갱신
		System.out.println("DustService fetchDustStations start");

		String reqUrl = stationBaseUrl + "?serviceKey=" + serviceKey + "&returnType=json" + "&numOfRows=1000"
				+ "&pageNo=1";

		try {
			String response = restTemplate.getForObject(reqUrl, String.class);

			JsonNode items = objectMapper.readTree(response).path("response").path("body").path("items");

			// JSON → DTO List 자동 변환
			List<DustDto> dtos = objectMapper.readerForListOf(DustDto.class).readValue(items);

			dustDao.deactivateAllStations();
			for (DustDto dto : dtos) {
				dto.setStationActive(true);
				dustDao.upsertStation(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("측정소 갱신 실패", e);
		}
	}

	/** 매 시간별 측정값 수집 */	
	@Override
	@Scheduled(cron = "0 15 * * * *")
	public void fetchDustMeasureHourly() { //1시간마다 권역별 측정소 데이터 api 호출 -> DB저장
	    System.out.println("fetchDustMeasureHourly start...1");

	    String[] sidos = { "서울","부산","대구","인천","광주","대전","울산","세종","경기","강원","충북","충남","전북","전남","경북","경남","제주" };

	    for (String sido : sidos) {
	        try {
	            String url = MeasureBaseUrl + "/getCtprvnRltmMesureDnsty"
	                    + "?serviceKey=" + serviceKey
	                    + "&returnType=json"
	                    + "&numOfRows=1000&pageNo=1"
	                    + "&sidoName=" + sido
	                    + "&ver=1.4";

	            String response = restTemplate.getForObject(url, String.class);

	            // JSON 대신 XML이 오면(<로 시작) 에러 처리
	            if (response.trim().startsWith("<")) {
	                System.err.println("API 오류 응답 (XML) → sido=" + sido);
	                System.err.println(response);
	                continue; // 다음 sido로 넘어가기
	            }

	            JsonNode items = objectMapper.readTree(response)
	                                         .path("response").path("body").path("items");

	            if (!items.isArray() || items.size() == 0) {
	                System.out.println("측정값 없음 → sido=" + sido);
	                continue;
	            }

	            List<DustDto> dtos = objectMapper.readerForListOf(DustDto.class).readValue(items);

	            for (DustDto dto : dtos) {
	                if (dto.getMeasureTime() == null) {
	                    dto.setMeasureTime(LocalDateTime.now());
	                }
	                dto.setSidoName(sido);
	            }

	            dustDao.upsertDustMeasure(dtos);
	            System.out.println("DB 저장 완료 → sido=" + sido + ", count=" + dtos.size());

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}


	@Override
	public List<DustDto> getDustMeasurements(String sido) {
		System.out.println("DustServiceImpl getDustMeasurements start...1");
		
		return dustDao.getDustMeasurements(sido);
	}

	@Override
	public List<DustDto> getLatestDustData() {
		System.out.println("DustServiceImpl getLatestDustData start...1");
		
		return dustDao.getLatestDustData();
	}
	
	@Scheduled(cron = "0 20 5,11,17,23 * * *")
	public void fetchDustForecast() {
	    String today = LocalDate.now().toString();
	    List<String> codes = List.of("PM10", "PM25");

	    for (String code : codes) {
	        String url = forecastBaseUrl
	                + "?serviceKey=" + serviceKey
	                + "&returnType=json&numOfRows=1000&pageNo=1"
	                + "&searchDate=" + today
	                + "&informCode=" + code
	                + "&ver=1.1";

	        try {
	            String response = restTemplate.getForObject(url, String.class);
	            JsonNode items = objectMapper.readTree(response)
	                                         .path("response").path("body").path("items");

	            System.out.println("API 응답 informCode=" + code);
	            System.out.println(items.toPrettyString());

	            if (!items.isArray() || items.size() == 0) {
	                System.out.println("예보 데이터 없음: " + today + " / " + code);
	                continue;
	            }

	            List<DustForecastDto> all = objectMapper.readerForListOf(DustForecastDto.class).readValue(items);

	            // 발표시각별 전체 저장
	            for (DustForecastDto dto : all) {
	                dustDao.fetchDustForecast(dto);
	                System.out.println("예보 저장 완료: " + dto.getDataTime() + " / " + dto.getInformCode());
	            }

	            // 이미지 저장은 17시에만
	            if (LocalDateTime.now(ZoneId.of("Asia/Seoul")).getHour() == 17) {
	                saveForecastImages(items, code);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}

	
	
	/** 실제 파일 저장 메서드 */
	private void saveForecastImages(JsonNode items, String code) {
	    for (JsonNode item : items) {
	        String dataTime = item.path("dataTime").asText();

	        String imgUrl = null;
	        if ("PM10".equalsIgnoreCase(code)) {
	            imgUrl = item.path("imageUrl7").asText(null);
	        } else if ("PM25".equalsIgnoreCase(code)) {
	            imgUrl = item.path("imageUrl8").asText(null);
	        }

	        if (imgUrl == null || imgUrl.isEmpty()) continue;

	        String savedPath = saveForecastImage(imgUrl, dataTime, code);

	        DustForecastDto imgDto = new DustForecastDto();
	        imgDto.setDataTime(dataTime);
	        imgDto.setInformCode(code);
	        imgDto.setType("dust");
	        imgDto.setPath(savedPath);

	        dustDao.upsertForecastImg(imgDto);
	    }
	}

	
	private String saveForecastImage(String imageUrl, String dataTime, String code) {
        try {
            String baseDir = "C:/upload/forecast";

            String datePart;
            try {
                LocalDate parsed = LocalDate.parse(dataTime.substring(0, 10));
                datePart = parsed.format(DateTimeFormatter.BASIC_ISO_DATE);
            } catch (Exception e) {
                datePart = LocalDate.now(ZoneId.of("Asia/Seoul"))
                                    .format(DateTimeFormatter.BASIC_ISO_DATE);
            }

            File dir = new File(baseDir + File.separator + datePart + File.separator + code);
            if (!dir.exists()) dir.mkdirs();

            String fileName = code + "_" + dataTime.replace(" ", "_").replace(":", "-") + ".gif";
            File outFile = new File(dir, fileName);

            try (InputStream in = new URL(imageUrl).openStream()) {
                Files.copy(in, outFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            return "/forecast/" + datePart + "/" + code + "/" + fileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

	@Override
	public DustForecastDto getForecastData(DustForecastDto dustForecastDto) {

		return dustDao.getForecastData(dustForecastDto);
	}
	
	
}
