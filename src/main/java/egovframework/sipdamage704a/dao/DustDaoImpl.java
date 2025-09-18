package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.dust.DustDto;
import egovframework.sipdamage704a.dto.dust.DustForecastDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DustDaoImpl implements DustDao {
	private final SqlSession session;
	
	@Override
	public void upsertStation(DustDto dto) {
		
		session.insert("upsertStation", dto);
		session.insert("upsertStationSido", dto);
	}

	@Override
	public List<DustDto> getDustStation() {

		return session.selectList("getDustStation");
	}

	@Override
	public void deactivateAllStations() {

		session.update("deactivateAllStations");
	}

	@Override
	public List<String> getActiveDustStations() {

		return session.selectList("getActiveDustStations");
	}

	@Override
	public void upsertDustMeasure(List<DustDto> list) {
		System.out.println("DustDaoImpl upsertDustMeasure start2");
		session.insert("upsertDustMeasure", list);
	}

	@Override
	public List<DustDto> getDustMeasurements(String sido) {

		return session.selectList("getDustMeasurements", sido);
	}

	@Override
	public List<DustDto> getLatestDustData() {

		return session.selectList("getLatestDustData");
	}

	@Override
	public void fetchDustForecast(DustForecastDto dto) {
		
		session.insert("fetchDustForecast", dto);
	}

	@Override
	public void upsertForecastImg(DustForecastDto imgDto) {
		
		session.insert("upsertForecastImg", imgDto);
	}

	@Override
	public DustForecastDto getForecastData(DustForecastDto dustForecastDto) {

		return session.selectOne("getForecastData", dustForecastDto);
	}

	
}
