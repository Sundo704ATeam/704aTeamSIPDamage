package egovframework.sipdamage704a.dto.damage;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ConstImpDto {
	
	private int managecode;		 //관리코드
	private String crack;		 //균열영향도
	private String elecleak;	 //누전영향도
	private String leak;		 //누수영향도
	private String variation;	 //변형영향도
	private String abnormality;  //구조이상도
}
