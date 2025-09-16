package egovframework.sipdamage704a.service;

import java.util.Map;


public interface DamageService {

    // 기존 점검 최신 조회
    Map<String, Object> findLatestByUfid(int managecode);


}
