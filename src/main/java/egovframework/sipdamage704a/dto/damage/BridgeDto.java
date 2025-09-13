package egovframework.sipdamage704a.dto.damage;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BridgeDto {
	private String ufid;	//도형코드
	private String name;	//명칭
	private double leng;	//길이
	private double widt;	//폭
	private String eymd;	//설치연도
	private String type;	//형태
	private String rest;	//기타
	private String scls;	//통합코드
	private String fmta;	//제작정보

}
