package egovframework.sipdamage704a.dao;

import java.util.List;

import egovframework.sipdamage704a.dto.damage.StructureDto;

public interface StructureDao {

	List<StructureDto> getAllStructures();
	StructureDto getStructureByManagecode(int managecode);
	List<StructureDto> getHoshiList();
	void updateHoshi(int managecode);


}
