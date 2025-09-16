package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;

public interface RainfallService {
	public void saveRainfallsUntilNow();
	public List<RainfallDto> getRainfalls();
	public List<GaugeDto> getGauges();
}
