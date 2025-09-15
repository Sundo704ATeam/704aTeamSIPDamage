package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RainfallDaoImpl implements RainfallDao {
	
	 private final SqlSession session;

	@Override
	public String getLatestTime() {
		String time = null;
		
		try {
			time = session.selectOne("selectLatestTime");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return time;
	}

	@Override
	public void saveRainfalls(List<RainfallDto> rainfalls) {
		try {
			session.insert("insertRainfalls", rainfalls);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<String> getAllGuName() {
		List<String> guNames = null;
		
		try {
			guNames = session.selectList("selectGuNames");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return guNames;
	}

	@Override
	public List<RainfallDto> getRainfalls() {
		List<RainfallDto> rainfalls = null;
		
		try {
			rainfalls = session.selectList("selectRainfalls");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rainfalls;
	}

	@Override
	public List<GaugeDto> getGauges() {
		List<GaugeDto> gauges = null;
		
		try {
			gauges = session.selectList("selectGauges");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return gauges;
	}

	@Override
	public void deleteOldRainfalls() {
		try {
			session.delete("deleteOldRainfalls");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
