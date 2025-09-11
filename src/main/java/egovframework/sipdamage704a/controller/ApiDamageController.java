package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.service.DamageService;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/damage")
public class ApiDamageController {

	private final DamageService damageService;
	
	@GetMapping("/{ufid}/inspection")
	public List<Damage_InspectDto> inspection(@PathVariable(name = "ufid") String ufid){
		System.out.println("ufid => " +ufid);
		
		return null;
	}
	
}
