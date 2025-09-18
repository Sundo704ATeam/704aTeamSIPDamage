package egovframework.sipdamage704a.service;

import java.util.List;
import java.util.Map;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;


public interface DamageService {

    // 기존 점검 최신 조회
    Map<String, Object> findLatestByUfid(int managecode);

	int saveInspect(Damage_InspectDto damage_InspectDto);

	Damage_InspectDto getFindByInscode(int inscode);

	List<Map<String, Object>> getDamageHistory(int managecode);


}
