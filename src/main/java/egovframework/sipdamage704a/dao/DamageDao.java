package egovframework.sipdamage704a.dao;

import java.util.Map;

import egovframework.sipdamage704a.dto.damage.bridgeDto;

public interface DamageDao {

	Map<String, Object> findLatestByUfid(String ufid);

    bridgeDto selectBridge(String ufid);

}
 	