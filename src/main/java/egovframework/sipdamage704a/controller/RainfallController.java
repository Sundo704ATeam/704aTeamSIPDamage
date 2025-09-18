package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.sipdamage704a.dto.rain.GaugeDto;
import egovframework.sipdamage704a.dto.rain.RainfallDto;
import egovframework.sipdamage704a.service.RainfallService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rain")
@RequiredArgsConstructor
public class RainfallController {
	
	private final RainfallService rainfallService;
	
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
		List<String> dates = rainfallService.getGifPaths();
		model.addAttribute("dates", dates);
		return "my/rain_img";
	}
	
	@GetMapping("/img/{gifName}")
	@ResponseBody
	public ResponseEntity<Resource> getRainfallGif(@PathVariable("gifName") String gifName) {
		Resource gif = rainfallService.getGif(gifName);
		
		return ResponseEntity.ok()
							 .contentType(MediaType.parseMediaType("image/gif"))
							 .body(gif);
	}
}

