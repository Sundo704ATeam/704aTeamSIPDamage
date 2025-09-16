package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.dust.DustDto;

public interface DustService {

	List<DustDto> 		getDustStation();
	void 				fetchDustStations();
	void 				fetchDustMeasureHourly();
	List<DustDto>		getDustMeasurements(String sido);
}
