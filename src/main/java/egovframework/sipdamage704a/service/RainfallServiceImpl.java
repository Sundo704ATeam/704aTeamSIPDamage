package egovframework.sipdamage704a.service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.CompletableFuture;

import javax.annotation.PostConstruct;

import java.util.List;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.sipdamage704a.dao.RainfallDao;
import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class RainfallServiceImpl implements RainfallService {
	
	private final RainfallDao rainfallDao;
	private final RainfallAsyncService asyncService;
	
	/**
	 * DB에 저장된 마지막 강우량 시간 (정각 단위)
	 */
	private String getLatestTime() {
		String latestTime = rainfallDao.getLatestTime();
		if (latestTime == null) {
			latestTime = LocalDate.now().minusDays(14).format(DateTimeFormatter.ofPattern("YYYY-MM-dd 00:00"));
		}
		return latestTime;
	}
	
	/**
	 * 지역구 단위로 api 비동기 요청 후 리스트 통합
	 */
	@Override
	public List<RainfallDto> getAsyncRainfallsUntilNow() {
		List<String> guNames = rainfallDao.getAllGuName();

		String startTime = getLatestTime();
		List<CompletableFuture<List<RainfallDto>>> futures = guNames.stream()
																	.map(guName -> asyncService.getRainfallsUntilNow(startTime, guName))
																	.toList();
		List<RainfallDto> rainfalls = futures.stream()
											 .map(CompletableFuture::join)
			    							 .flatMap(List::stream)
			    							 .toList();
		asyncService.setLastCallTime(LocalDateTime.now());
		return rainfalls;
	}

	@Override
	public List<RainfallDto> getRainfalls() {
		List<RainfallDto> savedRainfalls = rainfallDao.getRainfalls();
		
		// 이전 외부 api 요청에서 10분이 지난 경우 요청
		LocalDateTime lastCall = asyncService.getLastCallTime();
		if(lastCall == null || Duration.between(lastCall, LocalDateTime.now()).abs().toMinutes() > 10) {
			List<RainfallDto> currRainfalls = getAsyncRainfallsUntilNow();
			savedRainfalls.addAll(currRainfalls);
			// 비동기 DB 저장
			asyncService.saveRainfallUntilNow(currRainfalls);
		}
		
		return savedRainfalls;
	}

	@Override
	public List<GaugeDto> getGauges() {
		return rainfallDao.getGauges();
	}

}