package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
	public String rainfallPage(Model model) {
		List<GaugeDto> gauges = rainfallService.getGauges();
		List<RainfallDto> rainfalls = rainfallService.getRainfalls();
		
		model.addAttribute("gauges", gauges);
		model.addAttribute("rainfalls", rainfalls);
		return "my/rain";
	}
	
}

