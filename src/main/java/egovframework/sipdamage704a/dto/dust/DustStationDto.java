package egovframework.sipdamage704a.dto.dust;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class DustStationDto {
	@JsonProperty("stationCode")
	private int 	stationCode;	//측정소 코드
	
	@JsonProperty("stationName")
	private String	stationName;	//측정소 이름
	
	@JsonProperty("addr")
	private String	stationAddr;	//측정소 주소
	
	@JsonProperty("mangName")
	private String 	mangName;       //측정망 정보
	
	@JsonProperty("dmX")
	private double 	lon;			//WGS84기반 X좌표
	
	@JsonProperty("dmY")
	private double 	lat;			//WGS84기반 Y좌표
	
	private boolean stationActive;	//측정소 활성화 여부
	
	@JsonProperty("dataTime")
	private Date	dataTime;		//측정일
	
	
	
}
