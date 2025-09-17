package egovframework.sipdamage704a.service;

import java.time.LocalDateTime;
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
				System.out.println(response);

				JsonNode items = objectMapper.readTree(response).path("response").path("body").path("items");

				System.out.println(items);

				List<DustDto> dtos = objectMapper.readerForListOf(DustDto.class).readValue(items);
				
				for (DustDto dto : dtos) {
				    if (dto.getMeasureTime() == null) {
				        dto.setMeasureTime(LocalDateTime.now());
				        dto.setSidoName(sido);
				    }
				}

				if (!dtos.isEmpty()) {
					dustDao.upsertDustMeasure(dtos);
				}
				else System.out.println("Empty!");

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		/*
		 * for (String sido : sidos) { try { URI uri =
		 * UriComponentsBuilder.fromHttpUrl(MeasureBaseUrl +
		 * "/getCtprvnRltmMesureDnsty") .queryParam("serviceKey", serviceKey) // 원문 키
		 * 그대로 .queryParam("returnType", "json").queryParam("numOfRows",
		 * 1000).queryParam("pageNo", 1) .queryParam("sidoName", sido) // 원문 "서울"
		 * .queryParam("ver", "1.0") // ★ ver=1.0 .encode(StandardCharsets.UTF_8) // 여기서
		 * 한 번만 인코딩 .build().toUri();
		 * 
		 * String response = restTemplate.getForObject(uri, String.class);
		 * 
		 * JsonNode root = objectMapper.readTree(response); String code =
		 * root.path("response").path("header").path("resultCode").asText(); String msg
		 * = root.path("response").path("header").path("resultMsg").asText(); JsonNode
		 * items = root.path("response").path("body").path("items");
		 * 
		 * if (!"00".equals(code)) { System.out.println("API 오류: " + code + " / " +
		 * msg); continue; } if (!items.isArray() || items.size() == 0) {
		 * System.out.println("시/도=" + sido + " 결과 0건(버전/인코딩/요청량 제한 확인)"); continue; }
		 * 
		 * // 숫자 필드에 '-' 내려오는 걸 대비하려면 커스텀 역직렬화(아래 2) 참고) List<DustDto> dtos =
		 * objectMapper.readerForListOf(DustDto.class).readValue(items);
		 * 
		 * dustDao.upsertDustMeasure(dtos); // 아래 3) 매퍼 추가 } catch (Exception e) {
		 * e.printStackTrace(); } }
		 */
		
		
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
	
}
