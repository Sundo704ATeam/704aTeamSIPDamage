package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.dust.DustDto;

public interface DustService {

	List<DustDto> 		getDustStation();					//Active 측정소 정보 조회
	void 				fetchDustStations();				//db에 측정소 갱신
	void 				fetchDustMeasureHourly();			//db에 1시간마다 측정값 넣기
	List<DustDto>		getLatestDustData();				//측정소별 최신데이터 조회
	List<DustDto>		getDustMeasurements(String sido);	//측정소별 측정데이터 조회(권역별api호출)
}
