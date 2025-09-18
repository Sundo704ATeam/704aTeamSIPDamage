package egovframework.sipdamage704a.dto.damage;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DamageImgDto {
    private int inscode;      // 점검번호 FK
    private int managecode;   // 관리번호
    private String img_loc;    // 위치
    private String filename;  // 파일명
    
    // 업로드 받을 때만 사용
    private List<MultipartFile> files; 
}
