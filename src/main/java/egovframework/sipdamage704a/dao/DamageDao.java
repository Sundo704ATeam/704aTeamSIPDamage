package egovframework.sipdamage704a.dao;

import java.util.Map;

import egovframework.sipdamage704a.dto.damage.BridgeDto;
import egovframework.sipdamage704a.dto.damage.FootBridgeDto;
import egovframework.sipdamage704a.dto.damage.TunnelDto;

public interface DamageDao {

	Map<String, Object> findLatestByUfid(String ufid);

    BridgeDto selectBridge(String ufid);

	FootBridgeDto selectFootBridge(String ufid);

	TunnelDto selectTunnel(String ufid);

}
 	