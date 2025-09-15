package egovframework.sipdamage704a.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.damage.BridgeDto;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class DamageDaoImpl implements DamageDao {
	
	private final SqlSession session;
	
	@Override
	public Map<String, Object> findLatestByUfid(String ufid) {
		Map<String, Object> result = session.selectOne("egovframework.DamageMapper.findLatestByUfid",ufid);
		return result;
	}

	@Override
	public BridgeDto selectBridge(String ufid) {
	    BridgeDto bridge = session.selectOne(
	        "egovframework.DetailMapper.selectBridge", ufid
	    );
	    return bridge;
	}



}
