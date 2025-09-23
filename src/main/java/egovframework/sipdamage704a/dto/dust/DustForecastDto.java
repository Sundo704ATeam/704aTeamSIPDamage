package egovframework.sipdamage704a.dto.dust;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@JsonIgnoreProperties(ignoreUnknown = true)
public class DustForecastDto {
	
	@JsonProperty("dataTime")
	private String dataTime;
	
	@JsonProperty("informCode")
	private String informCode;
	
	@JsonProperty("informOverall")
	private String informOverall;
	
	@JsonProperty("informCause")
	private String informCause;
	
	@JsonProperty("informGrade")
	private String informGrade;
	
	@JsonProperty("actionKnack")
	private String actionKnack;
	
	private String type;
	
	private String path;
	
	
}

