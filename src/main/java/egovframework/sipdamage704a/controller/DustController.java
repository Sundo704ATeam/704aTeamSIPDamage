package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.sipdamage704a.dto.dust.DustDto;
import egovframework.sipdamage704a.service.DustService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequiredArgsConstructor
public class DustController {
	private final DustService 	dustService;
	
	@GetMapping("/dust")
	public String dustPage() {
	 
		return "sw/Dust"; 
	}
	 
	@GetMapping("/dust24")
	public String dust24Page() {
	 
		return "sw/Dust24"; 
	}
	 
	@GetMapping("/dustTest") 
	public String dustTestPage() {
	 
		return "sw/DustTest"; 
	}
	 
	@GetMapping("/dustTest2") 
	public String dustTest2Page() {
	 
		 return "sw/DustTest2";
	}
	 
	@GetMapping("/realDust")
	public String realDustPage(Model model) {
		log.info("DustController realDustPage start");
		
		List<DustDto> getDustStation = dustService.getDustStation();
		List<DustDto> getLatestDustData = dustService.getLatestDustData();
		
		model.addAttribute("getDustStation", getDustStation);
		model.addAttribute("getLatestDustData", getLatestDustData);
		
		return "sw/RealDust";
	}
	
	@GetMapping("/fetchDustStations")
	@ResponseBody
	public String fetchDustStations() {
        dustService.fetchDustStations();
        
        return "OK";
    }
	
	@GetMapping("/dustMeasurements")
	@ResponseBody
	public List<DustDto> getDustMeasurements(@RequestParam String sido) {
		
	    return dustService.getDustMeasurements(sido);
	}
	
	
	
}
