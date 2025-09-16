package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.dust.DustDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DustDaoImpl implements DustDao {
	private final SqlSession session;
	
	@Override
	public void upsertStation(DustDto dto) {
		
		session.insert("upsertStation", dto);
	}

	@Override
	public List<DustDto> getDustStation() {

		return session.selectList("getDustStation");
	}

	@Override
	public void deactivateAllStations() {

		session.insert("deactivateAllStations");
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
	
}
