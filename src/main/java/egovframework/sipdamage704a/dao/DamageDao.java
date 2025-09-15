package egovframework.sipdamage704a.dao;

import java.util.Map;

import egovframework.sipdamage704a.dto.damage.BridgeDto;

public interface DamageDao {

	Map<String, Object> findLatestByUfid(int managecode);

    BridgeDto selectBridge(String ufid);



}
 	