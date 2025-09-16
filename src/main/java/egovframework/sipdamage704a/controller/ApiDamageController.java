package egovframework.sipdamage704a.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
	
	
	@GetMapping("/{managecode}/inspection")
	public Map<String, String> getInspection(@PathVariable(name = "managecode") int managecode){
		System.out.println("ApiDamageController getInspection ufid => " + managecode);
		Map<String, Object> row = damageService.findLatestByUfid(managecode);
		System.out.println("ApiDamageController getInspection managecode => " +managecode);
        if (row == null) return Map.of();

        // 손상유형 → 등급만 매핑
        Map<String, String> result = new LinkedHashMap<>();
        result.put("균열", (String) row.get("crackrate"));
        result.put("누전", (String) row.get("elecleakrate"));
        result.put("누수", (String) row.get("leakrate"));
        result.put("변형", (String) row.get("variationrate"));
        result.put("구조이상", (String) row.get("abnomalityrate"));
        return result;
	}
	
	
	
}
