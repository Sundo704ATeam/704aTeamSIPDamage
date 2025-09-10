package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.rain.RainfallDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RainfallDaoImpl implements RainfallDao {
	
	// private final SqlSession session;

	@Override
	public String getLatestTime() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void saveRainfalls(List<RainfallDto> rainfalls) {
//		try {
//			session.insert("insertRainfalls", rainfalls);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}

}
