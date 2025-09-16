package egovframework.sipdamage704a.service;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.sipdamage704a.dao.StructureDao;
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
	public StructureDto getStructureByManagecode(String managecode) {
        return structureDao.getStructureByManagecode(managecode);
	}

}
