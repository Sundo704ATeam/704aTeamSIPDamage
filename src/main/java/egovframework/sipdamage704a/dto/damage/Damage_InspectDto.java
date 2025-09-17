package egovframework.sipdamage704a.dto.damage;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Damage_InspectDto {
	
	private int inscode;		//점검번호	
	private int managecode;		//관리번호
	private int crackcnt;		//균열객체수
	private int elecleakcnt;	//누전객체수
	private int leakcnt;		//누수객체수
	private int variationcnt;	//변형객체수
	private int abnormalitycnt;	//구조이상객체수
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate ins_date;	//점검일
	private String inspactor;	//점검자
	
    // 영향도
    private int crack;		//균열등급
    private int elecleak;	//누전등급
    private int leak;		//누수등급	
    private int variation;	//변형등급
    private int abnormality;	//구조이상등급

    
    // 위험등급
    private String  crack_grade;		//균열등급
    private String  elecleak_grade;	//누전등급
    private String  leak_grade;		//누수등급	
    private String  variation_grade;	//변형등급
    private String  abnormality_grade;	//구조이상등급
}
