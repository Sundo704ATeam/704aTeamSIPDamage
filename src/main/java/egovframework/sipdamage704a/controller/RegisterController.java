package egovframework.sipdamage704a.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/sj")
public class RegisterController {

	@GetMapping("/registerPage")
	public String registerPage(
	        @RequestParam String x,  // ← 문자열로 받음
	        @RequestParam String y,
	        Model model) {

	    model.addAttribute("x", x);
	    model.addAttribute("y", y);
	    return "sj/registerPage";
	}



}
