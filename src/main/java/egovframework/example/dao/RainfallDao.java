package egovframework.example.dao;

import java.util.List;

import egovframework.example.dto.rain.RainfallDto;

public interface RainfallDao {

	public String getLatestTime();
	public void saveRainfalls(List<RainfallDto> rainfalls);
	public List<String> getAllGuName();

}
