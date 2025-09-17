package egovframework.sipdamage704a.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.service.DamageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/damageMap")
public class DamageController {

	private final DamageService damageService;
	
	
	@GetMapping("")
	public String damageMap() {
		
		return "sj/damageMap";
	}
	
	
	@GetMapping("/inspect/new")
	public String inspectNewPage(@RequestParam("managecode") int managecode, Model model) {
		model.addAttribute("managecode", managecode);
		return "sj/inspectPage";
	}
	
	
	@PostMapping("/inspect/save")
	@ResponseBody
	public Map<String, Object> inspectSave(@RequestBody Damage_InspectDto dto) {
	    int result = damageService.saveInspect(dto);
	    Map<String, Object> res = new HashMap<>();
	    res.put("success", result > 0);
	    return res;
	}
	
	@GetMapping("/inspect/detail")
	public String inspectDetail(@RequestParam("inscode") int inscode ,Model model) {
		
		Damage_InspectDto damage_InspectDto = damageService.getFindByInscode(inscode);
		System.out.println("DamageController inspectDetail damage_InspectDto.겟매니지코드 => "+damage_InspectDto.getManagecode());
		
		
		
		
		model.addAttribute("damage_InspectDto", damage_InspectDto);
		model.addAttribute("managecode", damage_InspectDto.getManagecode());
		return "sh/inspectDetail";
	}
	
}