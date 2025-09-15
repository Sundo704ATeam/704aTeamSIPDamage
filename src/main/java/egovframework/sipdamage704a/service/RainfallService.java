package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;

public interface RainfallService {
	public void saveRainfallsUntilNow(String startTime, String guName);
	public List<RainfallDto> getRainfallsUntilNow(String startTime, String guName);
	public List<RainfallDto> getRainfalls();
	public List<GaugeDto> getGauges();
}
