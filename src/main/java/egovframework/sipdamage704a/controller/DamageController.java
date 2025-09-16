package egovframework.sipdamage704a.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DamageController {

	@GetMapping("damageMap")
	public String damageMap() {
		
		return "sj/damageMap";
	}
	
}