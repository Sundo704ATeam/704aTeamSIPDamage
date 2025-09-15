package egovframework.sipdamage704a.dto.rain;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RainfallDto {
	private int gauge_code;
	private String time;
	private double rainfall;
}
