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
	    return structureDao.getInspectsByManagecode(managecode);
	}

	@Override
	public void updateStructureBase(StructureDto dto) {
        structureDao.updateStructureBase(dto);
	}

	@Override
	public void updateStructureImpact(StructureDto dto) {
        structureDao.updateStructureImpact(dto);
	}



}
