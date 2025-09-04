package egovframework.example;

import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	
	private final DataSource dataSource;
	
	
	
	@GetMapping("/")
	public String mainPage(Model model) {
		String message = "HEALTH CHECK SUCCESS";
		
		try {
			dataSource.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
			message = "DB CONNECTION ERROR";
		} 
		
		model.addAttribute("message", message);
		
		return "test";
	}
}
