package egovframework.sipdamage704a.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageTypeSpecifier;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.metadata.IIOInvalidTreeException;
import javax.imageio.metadata.IIOMetadata;
import javax.imageio.metadata.IIOMetadataNode;
import javax.imageio.stream.ImageOutputStream;

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
	
	// 예측 이미지 조회
	@Value("${weatherHub.key}")
	private String weatherHubKey;
	private final String basePreImgUrl = "https://apihub.kma.go.kr/api/typ03/cgi/dfs/nph-qpf_ana_img";
	private final String preImgUrlQuery = "qpf=B&map=HR&legend=1&size=600";
	
	@Value("${path.gif.rainfall}")
	private String gifPath;
	
	@PostConstruct
	public void init() {
		File rainfallPath = new File(gifPath);
		if(rainfallPath.exists() == false) {
			rainfallPath.mkdirs();
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
	 * 금일 gif 생성 (예측) 
	 */
	@Async
	@Scheduled(cron = "0 15 0,12 * * *")
	public void saveTodayGif() {
		LocalDateTime now = LocalDateTime.now();
		String today = now.format(DateTimeFormatter.ofPattern("YYYYMMdd"));
		
		// 이미지 목록
		List<BufferedImage> imgs = new ArrayList<BufferedImage>();
		
		// 오전 예측
		String predictTime = today + "0000";
		for (int interval=30; interval<=720; interval+=30) {
			try {
				String url = basePreImgUrl + "?" + preImgUrlQuery + "&tm=" + predictTime + "&authKey=" + weatherHubKey + "&ef=" + interval;
				imgs.add(ImageIO.read(new URL(url)));
				
			} catch (MalformedURLException e) {
				continue;
			} catch (IOException e) {
				continue;
			}
		}
		
		// 오후 예측 추가
		boolean isAfternoon = now.isAfter(LocalDateTime.of(now.toLocalDate(), LocalTime.NOON));
		if (isAfternoon) {
			predictTime = today + "1200";
			for (int interval=30; interval<=720; interval+=30) {
				try {
					String url = basePreImgUrl + "?" + preImgUrlQuery + "&tm=" + predictTime + "&authKey=" + weatherHubKey + "&ef=" + interval;
					imgs.add(ImageIO.read(new URL(url)));
					
				} catch (MalformedURLException e) {
					continue;
				} catch (IOException e) {
					continue;
				}
			}
		}
			
		// gif 생성 및 저장
		createAndSaveGif(imgs, today, isAfternoon ? 1 : 2);
	}
	
	/**
	 * 전일 gif 생성
	 */
	@Async
	@Scheduled(cron = "0 10 0 * * *")
	public void saveYesterdayGif() {
		String yesterday = LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern("YYYYMMdd"));
		
		// 이미지 url 목록
		List<String> imgUrls = getPastImgUrls(yesterday);
		
		// 이미지 목록
		List<BufferedImage> imgs = new ArrayList<BufferedImage>();
		for (int i=0; i<imgUrls.size(); i++) {
			try {
				// 5분 단위 -> 30분 단위 이미지 추출
				if (i % 6 != 0) continue;
				imgs.add(ImageIO.read(new URL(imgUrls.get(i))));
				
			} catch (MalformedURLException e) {
				continue;
			} catch (IOException e) {
				continue;
			}
		}

		// gif 생성 및 저장
		createAndSaveGif(imgs, yesterday, 1);
		
		// 2주전 데이터 삭제
	}
	
	/**
	 * 시간별 강우량 이미지 url 목록 조회
	 * 공공데이터포털 openAPI 사용 (https://www.data.go.kr/data/15056924/openapi.do)
	 * 
	 * @param date YYYYMMdd 형식의 날짜 문자열 (오늘 기준 1일전까지 가능)
	 * @return 강우량 이미지 url 목록
	 */
	private List<String> getPastImgUrls(String date) {
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
	 * 이미지 목록으로 animated git 파일 생성 및 저장
	 * 
	 * @param imgs gif로 생성할 이미지 목록
	 * @param fileName 저장할 gif 파일 이름 ("YYYYMMdd" 형식으로 저장)
	 * @param delayTime 프레임당 멈출 시간 (10ms 단위)
	 */
	private void createAndSaveGif(List<BufferedImage> imgs, String fileName, int delayTime) {
		File outputFile = new File(gifPath + "/" + fileName + ".gif");
		
		// Gif writer
		Iterator<ImageWriter> writerIt = ImageIO.getImageWritersByFormatName("gif");
        if (!writerIt.hasNext()) {
            throw new RuntimeException("GIF ImageWriter를 찾을 수 없습니다. TwelveMonkeys 의존성을 확인하세요.");
        }
        ImageWriter writer = writerIt.next();
        
		try (ImageOutputStream ios = ImageIO.createImageOutputStream(outputFile)) {
            writer.setOutput(ios);
            ImageWriteParam param = writer.getDefaultWriteParam();
            writer.prepareWriteSequence(null);

            boolean firstFrame = true;
            for (BufferedImage frame : imgs) {
                IIOMetadata metadata = writer.getDefaultImageMetadata(new ImageTypeSpecifier(frame), param);
                String metaFormat = metadata.getNativeMetadataFormatName();
                IIOMetadataNode root = (IIOMetadataNode) metadata.getAsTree(metaFormat);

                // GraphicControlExtension (프레임 딜레이 등)
                IIOMetadataNode gce = getNode(root, "GraphicControlExtension");
                gce.setAttribute("disposalMethod", "none");
                gce.setAttribute("userInputFlag", "FALSE");
                gce.setAttribute("transparentColorFlag", "FALSE");
                gce.setAttribute("delayTime", Integer.toString(delayTime)); // 단위: 1/100초 (여기선 10 => 100ms)

                // ApplicationExtensions (NETSCAPE loop) - 첫프레임에만 추가
                if (firstFrame) {
                    IIOMetadataNode appExtensions = getNode(root, "ApplicationExtensions");
                    IIOMetadataNode appNode = new IIOMetadataNode("ApplicationExtension");
                    appNode.setAttribute("applicationID", "NETSCAPE");
                    appNode.setAttribute("authenticationCode", "2.0");
                    // gif 무한 반복: 0x1, 0x00, 0x00
                    appNode.setUserObject(new byte[]{0x1, 0x0, 0x0});
                    appExtensions.appendChild(appNode);
                    firstFrame = false;
                }

                try {
					metadata.setFromTree(metaFormat, root);
					writer.writeToSequence(new IIOImage(frame, null, metadata), param);
					
				} catch (IIOInvalidTreeException e) {
					continue;
				} catch (IOException e) {
					continue;
				}
            }

            writer.endWriteSequence();
            
        } catch (IOException e) {
			e.printStackTrace();
		} finally {
            writer.dispose();
        }
	}
	
	private static IIOMetadataNode getNode(IIOMetadataNode rootNode, String nodeName) {
        for (int i = 0; i < rootNode.getLength(); i++) {
            if (rootNode.item(i).getNodeName().equalsIgnoreCase(nodeName)) {
                return (IIOMetadataNode) rootNode.item(i);
            }
        }
        IIOMetadataNode node = new IIOMetadataNode(nodeName);
        rootNode.appendChild(node);
        return node;
    }
	
}
