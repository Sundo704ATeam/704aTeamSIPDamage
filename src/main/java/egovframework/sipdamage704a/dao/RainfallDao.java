package egovframework.sipdamage704a.dao;

import java.util.List;

import egovframework.sipdamage704a.dto.rain.RainfallDto;

public interface RainfallDao {

	public String getLatestTime();
	public void saveRainfalls(List<RainfallDto> rainfalls);

}
