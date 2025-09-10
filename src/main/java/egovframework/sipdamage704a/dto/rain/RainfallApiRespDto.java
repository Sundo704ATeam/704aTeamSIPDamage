package egovframework.sipdamage704a.dto.rain;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RainfallApiRespDto {
	
	@JsonProperty("ListRainfallService")
	private ListRainfallService respData;
	
	@Getter
	@Setter
	public static class ListRainfallService {
		@JsonProperty("list_total_count")
		private int totalCount;
		
		@JsonProperty("row")
		private List<Rainfall> rainfalls;
	}
	
	@Getter
	@Setter
	public static class Rainfall {
		@JsonProperty("RAINGAUGE_CODE")
		private int gaugeCode;
		
		@JsonProperty("RECEIVE_TIME")
		private String time;
		
		@JsonProperty("RAINFALL10")
		private String rainfall;
	}

}
