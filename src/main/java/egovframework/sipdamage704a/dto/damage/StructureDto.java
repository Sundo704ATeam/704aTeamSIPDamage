package egovframework.sipdamage704a.dto.damage;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class StructureDto {
	private int managecode;	  //관리코드
	private String type;      //종류
	private String typedetail;//세부구분
	private String name;	  //이름
	private String address;	  //소재지
	private double x;		  //x좌표
	private double y;		  //y좌표
	private String sort;	  //종별
	private int hoshi;		  //즐겨찾기
	private String materials; //구조

	
	//최신 점검일 join
	private LocalDate latest_ins_date;  // 최근 점검일
    
	//건물 영향도 join
	private int crack;
    private int elecleak;
    private int leak;
    private int variation;
    private int abnormality;

}
