package egovframework.sipdamage704a.dto.dust;

import java.time.LocalDateTime;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class DustDto {
	
	@JsonProperty("stationName")	//@jsonproperty = json 필드이름과 자바 필드이름 매칭
	private String	stationName;	//측정소 이름
	
	@JsonProperty("addr")
	private String	stationAddr;	//측정소 주소
	
	@JsonProperty("mangName")
	private String 	mangName;       //측정망 정보	
	
	@JsonProperty("dmX")
	private double 	lon;			//WGS84기반 X좌표(경도)
	
	@JsonProperty("dmY")
	private double 	lat;			//WGS84기반 Y좌표(위도)
	
	private boolean stationActive;	//측정소 활성화 여부
	
	@JsonProperty("dataTime")
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm")
	private LocalDateTime measureTime;	//측정일
	
	private Double 	pm10;			//pm10(미세먼지) 수치
    private Double 	pm2_5;			//pm2.5(초미세먼지) 수치
    
    @JsonProperty("sidoName")
    private String 	sidoName;		//시도명
	
	//(pm10Value 들어올 때 호출)
    @JsonProperty("pm10Value")
    public void setPm10Value(String value) {
        this.pm10 = parseDouble(value);
    }

    //(pm25Value 들어올 때 호출)
    @JsonProperty("pm25Value")
    public void setPm25Value(String value) {
        this.pm2_5 = parseDouble(value);
    }
    
	
	private Double parseDouble(String value) {
        if (value == null || value.isEmpty() || "-".equals(value)) {
            return null;
        }
        try {
            return Double.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
	
	
}
