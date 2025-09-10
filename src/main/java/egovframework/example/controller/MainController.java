package egovframework.example.controller;

import java.sql.Connection;
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
		System.out.println("====================== START ======================");
		return "main";
	}
	
	@GetMapping("/healthcheck")
	public String testPage(Model model) {
		String message = "DB CONNECTION NULL";
		
		try { 
			dataSource.getConnection();
			message = "DB CONNECTION SUCCESS";
		} catch (SQLException e) {
			e.printStackTrace();
			message = "DB CONNECTION ERROR";
		}
	
		model.addAttribute("message", message);
		
		return "healthcheck";
	}
}
