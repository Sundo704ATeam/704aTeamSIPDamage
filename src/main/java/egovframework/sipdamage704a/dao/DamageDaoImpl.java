package egovframework.sipdamage704a.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DamageDaoImpl implements DamageDao {
	
	private final SqlSession session;
	
	@Override
	public Map<String, Object> findLatestByUfid(int managecode) {
		Map<String, Object> result = session.selectOne("egovframework.DamageMapper.findLatestByManagecode",managecode);
		return result;
	}

	@Override
	public int saveInspect(Damage_InspectDto damage_InspectDto) {
		// TODO Auto-generated method stub
		return session.insert("egovframework.DamageMapper.saveInspect", damage_InspectDto);
	}


}
