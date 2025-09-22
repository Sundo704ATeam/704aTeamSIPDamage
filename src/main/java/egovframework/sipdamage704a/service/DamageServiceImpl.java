package egovframework.sipdamage704a.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.sipdamage704a.dao.DamageDao;
import egovframework.sipdamage704a.dto.damage.DamageImgDto;
import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class DamageServiceImpl implements DamageService {

    private final DamageDao damageDao;

    @Override
    public Map<String, Object> findLatestByUfid(int managecode) {
        
    	Map<String, Object> result = damageDao.findLatestByUfid(managecode);
    	
    	// ✅ 반환용 Map 따로 준비 (원본 데이터 + 등급 정보 같이 넣을 수 있음)
        Map<String, Object> response = new HashMap<>(result);

        for (Map.Entry<String, Object> entry : result.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();

            if (value instanceof Number) { // int, double 등 숫자일 때만 처리
                int intValue = ((Number) value).intValue();

                // 예: 점수 기준으로 등급 나누기
                String grade;
                
                if (intValue >= 400) {
                    grade = "A";
                } else if (intValue >= 300) {
                    grade = "B";
                } else if (intValue >= 200) {
                    grade = "C";
                } else if (intValue >= 100) {
                    grade = "D";
                } else {
                    grade = "-";
                }

                // ✅ 원래 키에 "_grade" 붙여서 등급 정보 추가
                response.put(key + "_grade", grade);
            }
        }

        return response;
    }

    @Override
	public int saveInspect(Damage_InspectDto damage_InspectDto) {
		
		return damageDao.saveInspect(damage_InspectDto);
	}


    @Override
	public Damage_InspectDto getFindByInscode(int inscode) {
		Damage_InspectDto damage_InspectDto = damageDao.getFindByInscode(inscode);
		
		damage_InspectDto.setCrack_grade(grade(damage_InspectDto.getCrack()));
		damage_InspectDto.setElecleak_grade(grade(damage_InspectDto.getElecleak()));
		damage_InspectDto.setLeak_grade(grade(damage_InspectDto.getLeak()));
		damage_InspectDto.setVariation_grade(grade(damage_InspectDto.getVariation()));
		damage_InspectDto.setAbnormality_grade(grade(damage_InspectDto.getAbnormality()));
		
		return damage_InspectDto;
	}

	
	private String grade(int cnt) {
	    if (cnt >= 400) return "A"; // A
	    else if (cnt >= 300) return "B"; // B
	    else if (cnt >= 200) return "C"; // C
	    else if (cnt >= 100) return "D"; // D
	    else return "-"; // 없음
	}

	@Override
	public List<Map<String, Object>> getDamageHistory(int managecode) {
	    return damageDao.getDamageHistory(managecode);
	}

	@Override
	public void saveDamageImg(DamageImgDto saveDto) {
		damageDao.saveDamageImg(saveDto);
		
	}

	@Override
	public List<DamageImgDto> getImagesByInscode(int inscode) {
		return damageDao.findImagesByInscode(inscode);
	}

	@Override
	public List<Map<String, Object>> findTop5Crack() {
        return damageDao.findTop5Crack();
	}

	@Override
	public List<Map<String, Object>> findTop5eleleak() {
		return damageDao.findTop5elecleak();
	}

	@Override
	public List<Map<String, Object>> findTop5leak() {
		return damageDao.findTop5leak();
	}

	@Override
	public List<Map<String, Object>> findTop5variation() {
		return damageDao.findTopvariation();
	}

	@Override
	public List<Map<String, Object>> findTop5abnoramlity() {
		return damageDao.findTop5abnoramlity();
	}

	@Override
	public List<Map<String, Object>> findEmergencyCrack() {
	    return damageDao.findEmergencyCrack();
	}

	@Override
	public List<Map<String, Object>> findEmergencyElecLeak() {
	    return damageDao.findEmergencyElecLeak();
	}

	@Override
	public List<Map<String, Object>> findEmergencyLeak() {
	    return damageDao.findEmergencyLeak();
	}

	@Override
	public List<Map<String, Object>> findEmergencyVariation() {
	    return damageDao.findEmergencyVariation();
	}

	@Override
	public List<Map<String, Object>> findEmergencyAbnormality() {
	    return damageDao.findEmergencyAbnormality();
	}

	 @Override
	    public List<Map<String, Object>> findAvgRiskByDistrict() {
		 return damageDao.findAvgRiskByDistrict(); 
	}


	
	
}
