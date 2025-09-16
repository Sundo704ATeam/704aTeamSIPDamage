package egovframework.sipdamage704a.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
    public StructureDto getStructureByManagecode(String managecode) {
        return sqlSession.selectOne(namespace + ".getStructureByManagecode", managecode);
    }
}