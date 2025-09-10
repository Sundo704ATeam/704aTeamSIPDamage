package egovframework.SIPDamage;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DustController {

	@GetMapping("dust")
	public String dustPage() {
		
		return "sw/Dust";
	}
	
	@GetMapping("dust24")
	public String dust24Page() {
		
		return "sw/Dust24"; 
	}
	
	@GetMapping("dustTest")
	public String dustTestPage() {
		
		return "sw/DustTest"; 
	}
	
	@GetMapping("dustTest2")
	public String dustTest2Page() {
		
		return "sw/DustTest2";
	}
	
}
