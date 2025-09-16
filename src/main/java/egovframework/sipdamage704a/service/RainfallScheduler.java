package egovframework.sipdamage704a.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.imageio.ImageIO;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import egovframework.sipdamage704a.dao.RainfallDao;
import egovframework.sipdamage704a.dto.rain.RainfallDto;
import egovframework.sipdamage704a.dto.rain.RainfallImgUrlsApiRespDto;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RainfallScheduler {
	
	private final RainfallService rainfallService;
	private final RainfallDao rainfallDao;
	
	// 과거 이미지 조회
	@Value("${dataPortal.key}")
	private String dataPortalKey;
	private final String baseImgUrl = "https://apis.data.go.kr/1360000/RadarImgInfoService/getCmpImg";
	private final String imgUrlQuery = "dataType=json&data=CMP_WRC";
	
	@Value("${path.gif.rainfall}")
	private String imgPath;
	
	@PostConstruct
	public void init() {
		File rainfallPath = new File(imgPath);
		if(rainfallPath.exists() == false) {
			rainfallPath.mkdir();
		}
	}
	
	/**
	 * 현재까지의 강우량 정보 DB 동기화
	 */
	@Async
	@Scheduled(cron = "0 0 4 * * *")
	public void saveRainfallsUntilNow() {
		List<RainfallDto> rainfalls = rainfallService.getAsyncRainfallsUntilNow();
		rainfallDao.saveRainfalls(rainfalls);
		rainfallDao.deleteOldRainfalls();
	}
	
	/**
	 * 어제의 시간별 강우량 이미지로 하나의 GIF 생성
	 */
	@Async
	@Scheduled(cron = "0 2 16 * * *")
	public void saveYesterdayGif() {
		String yesterday = LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern("YYYYMMdd"));
		
		// 이미지 url 목록
		List<String> imgUrls = getYesterdayImgUrls(yesterday);
		
		// 이미지 목록
		List<BufferedImage> imgs = new ArrayList<BufferedImage>();
		for (String url : imgUrls) {
			try {
				ImageIO.read(new URL(url));
			} catch (MalformedURLException e) {
				continue;
			} catch (IOException e) {
				continue;
			}
		}

		// gif 생성 및 저장
		createAndSaveGif(imgs, yesterday, 100);
	}
	
	/**
	 * 시간별 강우량 이미지 url 목록 조회
	 * 공공데이터포털 openAPI 사용 (https://www.data.go.kr/data/15056924/openapi.do)
	 * 
	 * @param date YYYYMMdd 형식의 날짜 문자열
	 * @return 어제자 강우량 이미지 url 목록
	 */
	private List<String> getYesterdayImgUrls(String date) {
		String url = baseImgUrl + "?" + imgUrlQuery + "&serviceKey=" + dataPortalKey + "&time=" + date;
		
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
		HttpEntity entity = new HttpEntity(headers);
		
		RestTemplate rest = new RestTemplate();
		ResponseEntity<RainfallImgUrlsApiRespDto> resp = rest.exchange(url, HttpMethod.GET, entity, RainfallImgUrlsApiRespDto.class);
		String urls = resp.getBody().getResp().getBody().getItems().getItem().get(0).getUrls();
		
		String parsedUrls = urls.substring(1, urls.length() - 1);
        return Arrays.asList(parsedUrls.split(", "));
	}
	
	/**
	 * 이미지 목록으로 애니메이션 git 파일 생성 및 저장
	 * 
	 * @param imgs Gif로 생성할 이미지 목록
	 * @param fileName 저장할 git 파일 이름
	 * @param delayTime 프레임당 멈출 시간 (ms)
	 */
	private void createAndSaveGif(List<BufferedImage> imgs, String fileName, int delayTime) {
		
	}
}
