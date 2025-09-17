package egovframework.sipdamage704a.dao;

import java.util.List;

import egovframework.sipdamage704a.dto.dust.DustDto;

public interface DustDao {

	void 					upsertStation(DustDto dto);
	List<DustDto> 			getDustStation();
	void 					deactivateAllStations();
	List<String> 			getActiveDustStations();
	void 					upsertDustMeasure(List<DustDto> list);
	List<DustDto> 			getDustMeasurements(String sido);
	List<DustDto> 			getLatestDustData();
}
