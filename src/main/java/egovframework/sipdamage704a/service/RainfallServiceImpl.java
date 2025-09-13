package egovframework.sipdamage704a.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
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
import egovframework.sipdamage704a.dto.rain.RainfallApiRespDto;
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
	 * 스케줄러를 사용하여 새벽에 작업
	 */
//	@Scheduled(cron = "")
//	protected void saveRainfallsUntilYesterday() {
//		String latestTime = rainfallDao.getLatestTime();
//		
//		List<RainfallDto> rainfalls = getRainfallsUntilNow(null);
//	}
	
	/**
	 * DB에 저장되지 않은 현재까지의 강우량 정보 조회
	 * 서울열린광장 openAPI 사용 (https://data.seoul.go.kr/dataList/OA-1168/S/1/datasetView.do)
	 * 
	 * @param latestTime DB에 저장된 최근 시점 (YYYY-MM-DD HH:mm)
	 */
	protected List<RainfallDto> getRainfallsUntilNow(String latestTime) {
		if (latestTime == null) {
			latestTime = LocalDate.now().minusMonths(1).format(DateTimeFormatter.ofPattern("YYYY-MM-dd 00:00"));
		}
		
		List<RainfallDto> rainfalls = new ArrayList<RainfallDto>();
		
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
		
		HttpEntity entity = new HttpEntity(headers);
		String url = baseUrl + apiKey + urlPath;
		int start = 1, end = 1000;
		
//		boolean isStop = false;
//		while (!isStop) {
//			String pagingUrl = url + "/" + start + "/" + end;
//			ResponseEntity<RainfallApiRespDto> resp = rest.exchange(pagingUrl, HttpMethod.GET, entity, RainfallApiRespDto.class);
//			List<RainfallDto> respRainfalls = resp.getBody().getRespData().getRainfalls();
//			
//			break;
//		}
		
		// db test
		RainfallDto r = new RainfallDto();
		r.setGaugeCode(1000);
		r.setTime("TEST TIME");
		r.setRainfall("77");
		rainfalls.add(r);
		rainfallDao.saveRainfalls(rainfalls);
		
		return null;
	}

	/**
	 * DB에 저장되지 않은 현재까지의 강우량 정보 조회
	 */
	@Override
	public List<RainfallDto> getRainfalls() {
		getRainfallsUntilNow(null);
		
		return null;
	}
	
}
