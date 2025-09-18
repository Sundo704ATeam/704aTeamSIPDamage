package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.dust.DustDto;
import egovframework.sipdamage704a.dto.dust.DustForecastDto;

public interface DustService {

	List<DustDto> 			getDustStation();					//Active 측정소 정보 조회
	void 					fetchDustStations();				//db, 측정소 갱신
	void 					fetchDustMeasureHourly();			//db, 측정소 데이터 스케줄러(1시간)
	List<DustDto>			getLatestDustData();				//측정소별 최신데이터 조회
	List<DustDto>			getDustMeasurements(String sido);	//측정소별 측정데이터 조회(권역별api호출)
	void					fetchDustForecast();				//db, 예보데이터 갱신
	DustForecastDto 		getForecastData(DustForecastDto dustForecastDto); // 예보 데이터 조회
}
