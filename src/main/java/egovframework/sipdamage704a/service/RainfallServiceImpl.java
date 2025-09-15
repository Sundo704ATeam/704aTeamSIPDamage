package egovframework.sipdamage704a.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import egovframework.sipdamage704a.dao.RainfallDao;
import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallApiRespDto;
import egovframework.sipdamage704a.dto.rain.RainfallApiRespDto.Rainfall;
import egovframework.sipdamage704a.dto.rain.RainfallDto;

@Service
@Transactional
public class RainfallServiceImpl implements RainfallService {
	
	private final RainfallDao rainfallDao;
	
	private final String apiKey;
	private final String baseUrl = "http://openAPI.seoul.go.kr:8088/";
	private final String urlPath = "/json/ListRainfallService";
	
	public RainfallServiceImpl(RainfallDao rainfallDao, @Value("${dataPortal.key}") String apiKey) {
		this.rainfallDao = rainfallDao;
		this.apiKey = apiKey;
	}
	
	/**
	 * 현재까지의 강우량 정보 DB 동기화
	 */
	@Scheduled(cron = "0 0 4 * * *")
	protected void saveRainfallsUntilNow() {
		List<String> guNames = rainfallDao.getAllGuName();
		String latestTime = rainfallDao.getLatestTime();
		if (latestTime == null) {
			latestTime = LocalDate.now().minusDays(14).format(DateTimeFormatter.ofPattern("YYYY-MM-dd 00:00"));
		}
		
		for (String guName: guNames) saveRainfallsUntilNow(latestTime, guName);
		// rainfallDao.deleteOldRainfalls();
	}
	
	public void saveRainfallsUntilNow(String startTime, String guName) {
		List<RainfallDto> rainfalls = getRainfallsUntilNow(startTime, guName);
		rainfallDao.saveRainfalls(rainfalls);
		System.out.printf("========== [%s] 강우량 수집 완료 ==========\n", guName);
	}
	
	/**
	 * startTime부터 현재까지의 강우량 정보 조회
	 * 서울열린광장 openAPI 사용 (https://data.seoul.go.kr/dataList/OA-1168/S/1/datasetView.do)
	 * 
	 * @param startTime 데이터가 시작하는 정각 시간 (YYYY-MM-DD HH:00)
	 * @param guName 지역구 이름
	 */
	public List<RainfallDto> getRainfallsUntilNow(String startTime, String guName) {
		// API request
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
		
		HttpEntity entity = new HttpEntity(headers);
		String url = baseUrl + apiKey + urlPath;
		int start = 1, end = 1000;
		
		// 10분 단위 누적을 1시간 단위 누적으로 변환하여 데이터 생성
		// {gaugeCode: {time: rainfall}}
		Map<Integer, Map<String, RainfallDto>> gauges = new HashMap<>();
		boolean isStop = false;
		int retry = 0;
		
		while (!isStop) {
			String pagingUrl = url + "/" + start + "/" + end + "/" + guName;
			List<RainfallApiRespDto.Rainfall> respRainfalls = null;
			try {
				ResponseEntity<RainfallApiRespDto> resp = rest.exchange(pagingUrl, HttpMethod.GET, entity, RainfallApiRespDto.class);
				respRainfalls = resp.getBody().getRespData().getRainfalls();
				if (respRainfalls.size() < 1000) isStop = true;
				
			} catch (Exception e) {
				// server error
				if (retry++ < 3) continue;
				else break;
			}
			for (Rainfall r : respRainfalls) {
				int gaugeCode = r.getGaugeCode();
				String time = r.getTime().substring(0, 13) + ":00";		// 정각으로 변환
				double rainfall = Double.valueOf(r.getRainfall());
				
				if (time.compareTo(startTime) < 0 ) {
					isStop = true;
					break;
				}
				// 강우량계 추가
				if (!gauges.containsKey(gaugeCode)) gauges.put(gaugeCode, new HashMap<String, RainfallDto>());
				
				Map<String, RainfallDto> gaugeMap = gauges.get(gaugeCode);
				if (!gaugeMap.containsKey(time)) {
					// 새로운 정각 데이터
					gaugeMap.put(time, new RainfallDto(gaugeCode, time, rainfall));
				}
				else {
					// 기존 정각 데이터에 강우량 누적
					gaugeMap.get(time).setRainfall(gaugeMap.get(time).getRainfall() + rainfall);
				}
			}
			start += 1000;	end += 1000;
		}
		
		List<RainfallDto> rainfalls = new ArrayList<RainfallDto>();
		for (Map<String, RainfallDto> inner : gauges.values()) {
		    rainfalls.addAll(inner.values());
		}
		return rainfalls;
	}

	@Override
	public List<RainfallDto> getRainfalls() {
		List<RainfallDto> savedRainfalls = rainfallDao.getRainfalls();
		return savedRainfalls;
	}

	@Override
	public List<GaugeDto> getGauges() {
		return rainfallDao.getGauges();
	}
	
}
