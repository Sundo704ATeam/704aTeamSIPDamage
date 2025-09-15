package egovframework.sipdamage704a.dao;

import java.util.List;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;

public interface RainfallDao {

	public String getLatestTime();
	public void saveRainfalls(List<RainfallDto> rainfalls);
	public List<String> getAllGuName();
	public List<RainfallDto> getRainfalls();
	public List<GaugeDto> getGauges();
	public void deleteOldRainfalls();

}
