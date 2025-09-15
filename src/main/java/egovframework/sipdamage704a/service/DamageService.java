package egovframework.sipdamage704a.service;

import java.util.Map;
import egovframework.sipdamage704a.dto.damage.BridgeDto;


public interface DamageService {

    // 기존 점검 최신 조회
    Map<String, Object> findLatestByUfid(String ufid);

    // 교량 단건 조회
    BridgeDto getBridge(String ufid);


}
