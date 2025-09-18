package egovframework.sipdamage704a.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.damage.DamageImgDto;
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

	@Override
	public Damage_InspectDto getFindByInscode(int inscode) {
		
		return session.selectOne("egovframework.DamageMapper.getFindByInscode", inscode);
	}


	@Override
	public List<Map<String, Object>> getDamageHistory(int managecode) {
	    return session.selectList("egovframework.DamageMapper.getDamageHistory", managecode);
	}

	@Override
	public void saveDamageImg(DamageImgDto saveDto) {
		session.insert("egovframework.DamageMapper.saveDamageImg", saveDto);
		
	}

	@Override
	public List<DamageImgDto> findImagesByInscode(int inscode) {
		// TODO Auto-generated method stub
		return session.selectList("egovframework.DamageMapper.findImagesByInscode", inscode);
	}

}
