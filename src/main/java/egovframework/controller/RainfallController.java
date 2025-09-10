package egovframework.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.service.RainfallService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rain")
@RequiredArgsConstructor
public class RainfallController {
	
	private final RainfallService rainfallService;
	
	@GetMapping("/test")
	public String test() {
		
		rainfallService.getRainfalls();
		
		return "redirect:/";
	}
	
}
