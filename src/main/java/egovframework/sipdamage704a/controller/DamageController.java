package egovframework.sipdamage704a;

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
	
	@GetMapping("diagnose")
	public String diagnose() {
		
		return "sj/diagnose";
	}

	
}
