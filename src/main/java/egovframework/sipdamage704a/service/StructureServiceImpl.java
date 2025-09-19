package egovframework.sipdamage704a.service;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.sipdamage704a.dao.StructureDao;
import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;

@Service
@Transactional
public class StructureServiceImpl implements StructureService {

    @Autowired
    private StructureDao structureDao;

	@Override
	public List<StructureDto> getAllStructures() {
        return structureDao.getAllStructures();
	}

	@Override
	public StructureDto getStructureByManagecode(int managecode) {
        return structureDao.getStructureByManagecode(managecode);
	}

	@Override
	public List<StructureDto> getHoshiList() {
		
		return structureDao.getHoshiList();
	}

	@Override
	public void updateHoshi(int managecode) {
		structureDao.updateHoshi(managecode);
	}

	@Override
	public List<Damage_InspectDto> getInspectsByManagecode(int managecode) {
	    
		List<Damage_InspectDto> result = structureDao.getInspectsByManagecode(managecode);
		
				for(Damage_InspectDto dto : result) {
					dto.setCrack_grade(grade(dto.getCrack()*dto.getCrackcnt()));
					dto.setElecleak_grade(grade(dto.getElecleak()*dto.getElecleakcnt()));
					dto.setLeak_grade(grade(dto.getLeak()*dto.getLeakcnt()));
					dto.setVariation_grade(grade(dto.getVariation()*dto.getVariationcnt()));
					dto.setAbnormality_grade(grade(dto.getAbnormality()*dto.getAbnormalitycnt()));
				}
		return result ;
	}

	@Override
	public void updateStructureBase(StructureDto dto) {
        structureDao.updateStructureBase(dto);
	}

	@Override
	public void updateStructureImpact(StructureDto dto) {
        structureDao.updateStructureImpact(dto);
	}

	@Override
	public void registerStructure(StructureDto dto) {
    structureDao.registerStructure(dto);
    structureDao.registerStructureImpact(dto);

	}


	private String grade(int cnt) {
	    if (cnt >= 400) return "A"; // A
	    else if (cnt >= 300) return "B"; // B
	    else if (cnt >= 200) return "C"; // C
	    else if (cnt >= 100) return "D"; // D
	    else return "-"; // 없음
	}

	@Override
	public List<StructureDto> searchStructures(String filter, String keyword) {
        return structureDao.searchStructures(filter, keyword);
	}




}
