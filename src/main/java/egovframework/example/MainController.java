package egovframework.example;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	
	//private final DataSource dataSource;
	
	
	@GetMapping("/hi")
	public String mainPage(Model model) {

		return "test2";
	}
	
	
}
