package egovframework.sipdamage704a.dao;

import java.util.List;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;

public interface StructureDao {

	List<StructureDto> getAllStructures();
	StructureDto getStructureByManagecode(int managecode);
	List<StructureDto> getHoshiList();
	void updateHoshi(int managecode);
	List<Damage_InspectDto> getInspectsByManagecode(int managecode);
	void updateStructureBase(StructureDto dto);	
	void updateStructureImpact(StructureDto dto);
	void registerStructure(StructureDto dto);
	void registerStructureImpact(StructureDto dto);

}
