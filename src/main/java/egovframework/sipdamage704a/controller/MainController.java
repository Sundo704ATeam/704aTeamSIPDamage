package egovframework.sipdamage704a.controller;

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

	@GetMapping("/")
	public String mainPage(Model model) {
		System.out.println("====================== START ======================");
		return "main";
	}
	
}
