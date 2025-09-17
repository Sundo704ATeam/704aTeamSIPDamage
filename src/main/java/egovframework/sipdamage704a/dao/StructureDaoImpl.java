package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;

@Repository
public class StructureDaoImpl implements StructureDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String namespace = "egovframework.sipdamage704a.dao.StructureDao";

    @Override
    public List<StructureDto> getAllStructures() {
        return sqlSession.selectList(namespace + ".getAllStructures");
    }

    @Override
    public StructureDto getStructureByManagecode(int managecode) {
        return sqlSession.selectOne(namespace + ".getStructureByManagecode", managecode);
    }

	@Override
	public List<StructureDto> getHoshiList() {
		
		return sqlSession.selectList(namespace + ".getHoshiList");
	}

	@Override
	public void updateHoshi(int managecode) {
		sqlSession.update(namespace + ".updateHoshi", managecode);
	}

	@Override
	public List<Damage_InspectDto> getInspectsByManagecode(int managecode) {
	    return sqlSession.selectList(namespace + ".getInspectsByManagecode", managecode);
	}

	@Override
	public void updateStructureBase(StructureDto dto) {
        sqlSession.update(namespace + ".updateStructureBase", dto);		
	}

	public void updateStructureImpact(StructureDto dto) {
        sqlSession.update(namespace + ".updateStructureImpact", dto);		
	}

	@Override
	public void registerStructure(StructureDto dto) {
        sqlSession.insert(namespace + ".registerStructure", dto);
	}

	@Override
	public void registerStructureImpact(StructureDto dto) {
        sqlSession.insert(namespace + ".registerStructureImpact", dto);
	}


}