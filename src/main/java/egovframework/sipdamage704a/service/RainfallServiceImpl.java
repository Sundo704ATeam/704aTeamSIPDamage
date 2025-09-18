package egovframework.sipdamage704a.service;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.CompletableFuture;

import javax.annotation.PostConstruct;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
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
	
	@Value("${path.gif.rainfall}")
	private String gifPath;
	
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

	@Override
	public List<String> getGifPaths() {
		File dir = new File(gifPath);
		List<String> gifs = Arrays.asList(dir.list());
		
		// 최신순 정렬
		gifs.sort(Comparator.reverseOrder());
		return gifs;
	}

	@Override
	public Resource getGif(String gifName) {
		Path fullPath = Paths.get(gifPath).resolve(gifName).normalize();
		Resource gif = new FileSystemResource(fullPath);
		
		if (!gif.exists()) return null;
		return gif;
	}

}