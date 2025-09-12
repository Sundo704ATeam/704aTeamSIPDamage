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
	
	@GetMapping("/{ufid}/inspection")
	public Map<String, String> getInspection(@PathVariable(name = "ufid") String ufid){
		System.out.println("ApiDamageController getInspection ufid => " +ufid);
		Map<String, Object> row = damageService.findLatestByUfid(ufid);
		System.out.println("ApiDamageController getInspection row => " +row);
        if (row == null) return Map.of();

        // 손상유형 → 등급만 매핑
        Map<String, String> result = new LinkedHashMap<>();
        result.put("균열", (String) row.get("crack_ins"));
        result.put("누전", (String) row.get("elecLeakage_ins"));
        result.put("누수", (String) row.get("leakage_ins"));
        result.put("변형", (String) row.get("deformation_ins"));
        result.put("구조이상", (String) row.get("anomaly_ins"));
        return result;
	}
	
}
