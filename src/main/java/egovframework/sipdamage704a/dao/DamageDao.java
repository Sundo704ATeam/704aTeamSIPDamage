package egovframework.sipdamage704a.dao;

import java.util.List;
import java.util.Map;

import egovframework.sipdamage704a.dto.damage.DamageImgDto;
import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;

public interface DamageDao {

	Map<String, Object> findLatestByUfid(int managecode);

	int saveInspect(Damage_InspectDto damage_InspectDto);

	Damage_InspectDto getFindByInscode(int inscode);

	List<Map<String, Object>> getDamageHistory(int managecode);
	
	void saveDamageImg(DamageImgDto saveDto);

	List<DamageImgDto> findImagesByInscode(int inscode);

	List<Map<String, Object>> findTop5Crack();

	List<Map<String, Object>> findTop5elecleak();

	List<Map<String, Object>> findTop5leak();

	List<Map<String, Object>> findTopvariation();

	List<Map<String, Object>> findTop5abnoramlity();

}
 	