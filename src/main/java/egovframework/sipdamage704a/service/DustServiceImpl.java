/*
 * package egovframework.sipdamage704a.service;
 * 
 * import java.util.List;
 * 
 * import org.springframework.scheduling.annotation.Scheduled; import
 * org.springframework.stereotype.Service; import
 * org.springframework.transaction.annotation.Transactional;
 * 
 * import egovframework.sipdamage704a.dao.DustDao; import
 * egovframework.sipdamage704a.dto.dust.DustStationDto; import
 * lombok.RequiredArgsConstructor;
 * 
 * @Service
 * 
 * @Transactional
 * 
 * @RequiredArgsConstructor public class DustServiceImpl implements DustService
 * { private final DustDao dustDao;
 * 
 * @Override public List<DustStationDto> getDustStation() {
 * System.out.println("DustServiceImpl getDustStation start");
 * 
 * 
 * return null; }
 * 
 * @Scheduled(cron = "0 0 0 1 * *") public void fetchDustStations() {
 * System.out.println("DustService fetchDustStations start");
 * 
 * } }
 */