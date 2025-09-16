package egovframework.sipdamage704a.service;

import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.sipdamage704a.dao.DamageDao;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class DamageServiceImpl implements DamageService {

    private final DamageDao damageDao;

    @Override
    public Map<String, Object> findLatestByUfid(int managecode) {
        return damageDao.findLatestByUfid(managecode);
    }

}
