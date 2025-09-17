package egovframework.sipdamage704a.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;import egovframework.sipdamage704a.dao.StructureDao;
import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;
import egovframework.sipdamage704a.service.DamageService;
import egovframework.sipdamage704a.service.StructureService;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/damage")
public class ApiDamageController {

	private final DamageService damageService;
	private final StructureService structureService;
	
	@GetMapping("/{managecode}/inspection")
	public Map<String, String> getInspection(@PathVariable(name = "managecode") int managecode){
		System.out.println("ApiDamageController getInspection ufid => " + managecode);
		Map<String, Object> row = damageService.findLatestByUfid(managecode);
		System.out.println("ApiDamageController getInspection managecode => " +managecode);
        if (row == null) return Map.of();

        // 손상유형 → 등급만 매핑
        Map<String, String> result = new LinkedHashMap<>();
        result.put("균열", (String) row.get("crack_grade"));
        result.put("누전", (String) row.get("elecleak_grade"));
        result.put("누수", (String) row.get("leak_grade"));
        result.put("변형", (String) row.get("variation_grade"));
        result.put("구조이상", (String) row.get("abnormality_grade"));
        return result;
	}
	
	
	@GetMapping("/hoshi")
	public List<StructureDto> getHoshiList(){
		List<StructureDto> result = structureService.getHoshiList();
		System.out.println("ApiDamageController getHoshiList result => " +result.size());
		
		return result;
	}
	
	@GetMapping("/hoshi/status")
	public StructureDto hoshiStatus(@RequestParam int managecode) {
		System.out.println("ApiDamageController hoshiStatus managecode => "+managecode);
		StructureDto result = structureService.getStructureByManagecode(managecode);
		
		return result;
		
	}
	
	@PostMapping("/hoshi/toggle")
	public StructureDto hoshitoggle(@RequestBody Map<String, String> body){
		System.out.println("ApiDamageController hoshiStatus body => "+body);
		int managecode = Integer.parseInt(body.get("managecode"));
		System.out.println("ApiDamageController hoshiStatus managecode => "+managecode);
		
		// 증겨찾기 정보수정
		structureService.updateHoshi(managecode);
		
		// 변경된 정보 조회
		StructureDto resultDto = structureService.getStructureByManagecode(managecode);
		System.out.println("hoshiStatus hoshitoggle resultDto => " +resultDto.getHoshi());
		
		
		return resultDto;
	}
	
	
}
