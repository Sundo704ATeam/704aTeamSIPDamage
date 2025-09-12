package egovframework.sipdamage704a.dao;

import java.util.Map;

public interface DamageDao {

	Map<String, Object> findLatestByUfid(String ufid);

}
