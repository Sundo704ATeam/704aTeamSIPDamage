package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;
import egovframework.sipdamage704a.service.RainfallScheduler;
import egovframework.sipdamage704a.service.RainfallService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rain")
@RequiredArgsConstructor
public class RainfallController {
	
	private final RainfallService rainfallService;
	
	
	private final RainfallScheduler sched;
	
	@GetMapping("")
	public String getRainfallPage(Model model) {
		List<GaugeDto> gauges = rainfallService.getGauges();
		List<RainfallDto> rainfalls = rainfallService.getRainfalls();
		
		model.addAttribute("gauges", gauges);
		model.addAttribute("rainfalls", rainfalls);
		return "my/rain";
	}
	
	@GetMapping("/img")
	public String getRainfallGifPage(Model model) {
		return "my/rain";
	}
	
	@GetMapping("/img/{imgPath}")
	@ResponseBody
	public ResponseEntity<MultipartFile> getRainfallGif(@PathVariable("imgPath") String imgPath) {
		return null;
	}
}

