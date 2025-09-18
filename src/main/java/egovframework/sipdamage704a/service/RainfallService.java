package egovframework.sipdamage704a.service;

import java.util.List;

import org.springframework.core.io.Resource;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;

public interface RainfallService {
	public List<RainfallDto> getAsyncRainfallsUntilNow();
	public List<RainfallDto> getRainfalls();
	public List<GaugeDto> getGauges();
	public List<String> getGifPaths();
	public Resource getGif(String gifName);
}
