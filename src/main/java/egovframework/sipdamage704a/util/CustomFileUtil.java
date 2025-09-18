package egovframework.sipdamage704a.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Component
@Log4j2
@RequiredArgsConstructor
public class CustomFileUtil {

    @Value("${upload.path}")
    private String uploadPath;

    @PostConstruct
    public void init() {
    	File tempFolder = new File(uploadPath, "inspect");
        if (!tempFolder.exists()) {
            tempFolder.mkdirs();
        }
        uploadPath = tempFolder.getAbsolutePath();
        log.info("업로드 경로 세팅 완료 => " + uploadPath);
    }

    // 파일 저장
    public List<String> saveFiles(List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            return null;
        }

        List<String> uploadNames = new ArrayList<>();
        for (MultipartFile multipartFile : files) {
            if (multipartFile.isEmpty()) continue;

            String savedName = UUID.randomUUID() + "_" + multipartFile.getOriginalFilename();
            File saveFile = new File(uploadPath, savedName);

            try {
                // ✅ 임시파일 → 최종 경로로 이동 (tmp 자동 삭제됨)
                multipartFile.transferTo(saveFile);

                uploadNames.add(savedName);
                log.info("파일 저장 완료 => " + savedName);
            } catch (IOException e) {
                throw new RuntimeException("파일 저장 실패: " + multipartFile.getOriginalFilename(), e);
            }
        }
        return uploadNames;
    }

    // 파일 삭제
    public void deleteFiles(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return;
        }

        Path filePath = Paths.get(uploadPath, fileName);
        try {
            Files.deleteIfExists(filePath);
            log.info("파일 삭제 완료 => " + fileName);
        } catch (IOException e) {
            throw new RuntimeException("파일 삭제 실패: " + fileName, e);
        }
    }

    // 파일 읽기
    public ResponseEntity<Resource> getFile(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = "default.jpg";
        }

        Resource resource = new FileSystemResource(uploadPath + File.separator + fileName);
        if (!resource.exists() || !resource.isReadable()) {
            resource = new FileSystemResource(uploadPath + File.separator + "default.jpg");
        }

        HttpHeaders headers = new HttpHeaders();
        try {
            headers.add("Content-Type", Files.probeContentType(resource.getFile().toPath()));
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }

        return ResponseEntity.ok().headers(headers).body(resource);
    }
}