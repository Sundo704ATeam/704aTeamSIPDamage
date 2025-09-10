package egovframework.dto.rain;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RainfallDto {
	@JsonProperty("RAINGAUGE_CODE")
	private int gaugeCode;
	
	@JsonProperty("RECEIVE_TIME")
	private String time;
	
	@JsonProperty("RAINFALL10")
	private String rainfall;
}
