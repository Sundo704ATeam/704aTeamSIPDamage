package egovframework.sipdamage704a.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.sipdamage704a.dto.dust.DustDto;
import egovframework.sipdamage704a.dto.dust.DustForecastDto;
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
	 
	@GetMapping("/realTimeDust")
	public String realTimeDustPage(Model model) {
		log.info("DustController realTimeDustPage start");
		
		List<DustDto> getDustStation = dustService.getDustStation();
		List<DustDto> getLatestDustData = dustService.getLatestDustData();
		
		model.addAttribute("getDustStation", getDustStation);
		model.addAttribute("getLatestDustData", getLatestDustData);
		
		return "sw/realTimeDust";
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
	
	@GetMapping("/dustData")
	public String dustDataPage(Model model) {
		log.info("DustController dustDataPage start");
		
		List<DustDto> getDustStation = dustService.getDustStation();
		List<DustDto> getDustMeasurements = dustService.getDustMeasurements("서울");
		
		model.addAttribute("getDustStation", getDustStation);
		model.addAttribute("getDustMeasurements", getDustMeasurements);
		
		return "sw/dustData";
	}
	
	@GetMapping("/dustForecast")
	public String dustForecastPage(@RequestParam(value = "informCode", required = false) String informCode,
	        					   @RequestParam(value = "dataTime", required = false) String dataTime,
	        					   Model model) {
	    log.info("DustController dustForecastPage start");

	    if (informCode == null && dataTime == null) {
	        informCode = "PM10";
	        dataTime = LocalDate.now().toString();
	    }
	    DustForecastDto dustForecastDto = new DustForecastDto();
	    dustForecastDto.setInformCode(informCode);
	    dustForecastDto.setDataTime(dataTime);
	    
	    DustForecastDto dustForecast = dustService.getForecastData(dustForecastDto);
	    System.out.println("dustForecast : " + dustForecast);
	    
	    model.addAttribute("dustForecast", dustForecast);

	    return "sw/dustForecast";
	}




	
}
