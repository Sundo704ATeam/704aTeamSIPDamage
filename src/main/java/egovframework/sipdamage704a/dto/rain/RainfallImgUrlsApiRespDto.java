package egovframework.sipdamage704a.dto.rain;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;

@Getter
public class RainfallImgUrlsApiRespDto {
	
	@JsonProperty("response")
	private Response resp;

	@Getter
	public static class Response {
		
		private Body body;
		
		@Getter
		public static class Body {
			
			private String dataType;
			private Items items;
			
			@Getter
			public static class Items {
				private List<Urls> item;
				
				@Getter
				public static class Urls {
					@JsonProperty("rdr-img-file")
					private String urls;
				}
			}
		}
	}
}
