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
	private int crack;			 //균열영향도
	private int elecleak;		 //누전영향도
	private int leak;			 //누수영향도
	private int variation;	 	//변형영향도
	private int abnormality;  	//구조이상도
}
