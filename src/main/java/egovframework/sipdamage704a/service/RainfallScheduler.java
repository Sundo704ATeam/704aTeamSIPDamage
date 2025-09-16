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
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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
import javax.servlet.ServletContext;

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
	 * 어제의 시간별 강우량 이미지로 하나의 GIF 생성
	 */
	@Async
	@Scheduled(cron = "0 0 2 * * *")
	public void saveYesterdayGif() {
		String yesterday = LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern("YYYYMMdd"));
		
		// 이미지 url 목록
		List<String> imgUrls = getYesterdayImgUrls(yesterday);
		
		// 이미지 목록
		List<BufferedImage> imgs = new ArrayList<BufferedImage>();
		for (String url : imgUrls) {
			try {
				imgs.add(ImageIO.read(new URL(url)));
			} catch (MalformedURLException e) {
				continue;
			} catch (IOException e) {
				continue;
			}
		}

		// gif 생성 및 저장
		createAndSaveGif(imgs, yesterday, 1);
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
	 * @param delayTime 프레임당 멈출 시간 (10ms 단위)
	 */
	private void createAndSaveGif(List<BufferedImage> imgs, String fileName, int delayTime) {
		File outputFile = new File(imgPath + "/" + fileName + ".gif");
		
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
                    // 무한 반복: 0x1, 0x00, 0x00
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
