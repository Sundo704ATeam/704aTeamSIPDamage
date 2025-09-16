package egovframework.sipdamage704a.service;

import java.util.List;

import egovframework.sipdamage704a.dto.damage.StructureDto;

public interface StructureService {
	
	  List<StructureDto> getAllStructures();
	  StructureDto getStructureByManagecode(int managecode);

}
