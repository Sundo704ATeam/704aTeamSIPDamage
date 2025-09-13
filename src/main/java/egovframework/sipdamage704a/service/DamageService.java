package egovframework.sipdamage704a.service;

import java.util.Map;
import egovframework.sipdamage704a.dto.damage.BridgeDto;
import egovframework.sipdamage704a.dto.damage.FootBridgeDto;
import egovframework.sipdamage704a.dto.damage.TunnelDto;

public interface DamageService {

    // 기존 점검 최신 조회
    Map<String, Object> findLatestByUfid(String ufid);

    // 교량 단건 조회
    BridgeDto getBridge(String ufid);

    //육교 단건 조회
	FootBridgeDto getFootBridge(String ufid);

	//터널 단건 조회 
	TunnelDto getTunnel(String ufid);
}
