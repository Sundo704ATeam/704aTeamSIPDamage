package egovframework.sipdamage704a.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.damage.bridgeDto;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DamageDaoImpl implements DamageDao {
	
	private final SqlSession session;
	
	@Override
	public Map<String, Object> findLatestByUfid(String ufid) {
		
		System.out.println("DamageDaoImpl findLatestByUfid ufid => "+ufid);
		Map<String, Object> result = session.selectOne("egovframework.DamageMapper.findLatestByUfid",ufid);
		System.out.println("DamageDaoImpl findLatestByUfid result => "+result);
		
		return result;
	}

	@Override
	public bridgeDto selectBridge(String ufid) {
	    System.out.println("DamageDaoImpl selectBridge ufid => " + ufid);
	    bridgeDto bridge = session.selectOne(
	        "egovframework.DetailMapper.selectBridge", ufid
	    );
	    System.out.println("DamageDaoImpl selectBridge result => " + bridge);
	    return bridge;
	}


}
