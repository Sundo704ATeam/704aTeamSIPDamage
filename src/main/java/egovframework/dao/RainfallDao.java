package egovframework.dao;

import java.util.List;

import egovframework.dto.rain.RainfallDto;

public interface RainfallDao {

	public String getLatestTime();
	public void saveRainfalls(List<RainfallDto> rainfalls);

}
