package egovframework.sipdamage704a.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;
import egovframework.sipdamage704a.service.StructureService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class StructureController {

    private final StructureService structureService;

    // 전체 조회 페이지 이동
    @GetMapping("/structureList")
    public String getAllStructures(Model model) {
        model.addAttribute("structures", structureService.getAllStructures());
        return "sj/structureList";  
    }

    // 상세 조회
    @GetMapping("/structureDetail")
    public String getStructureByManagecode(@RequestParam("managecode") int managecode, Model model) {
        StructureDto dto = structureService.getStructureByManagecode(managecode);
        model.addAttribute("structure", dto);
        return "sj/structureDetail"; 
    }
    
    // 특정 건물 점검 이력 조회
    @GetMapping("/inspectList")
    public String getInspectList(@RequestParam("managecode") int managecode, Model model) {
        List<Damage_InspectDto> list = structureService.getInspectsByManagecode(managecode);
        
        
        model.addAttribute("inspects", list);
        model.addAttribute("managecode", managecode);
        return "sj/inspectList";
    }
    
    
    // 업데이트 화면
    @GetMapping("/structureUpdate")
    public String getStructureByManagecode2(@RequestParam("managecode") int managecode, Model model) {
        StructureDto dto = structureService.getStructureByManagecode(managecode);
        model.addAttribute("structure", dto);
        return "sj/structureUpdate"; 
    }
    
    // 수정 저장
    @PostMapping("/structure/update")
    public String updateStructure(@ModelAttribute StructureDto dto) {
        structureService.updateStructureBase(dto);
        structureService.updateStructureImpact(dto);
        return "redirect:/structureDetail?managecode=" + dto.getManagecode();
    }
    
    
}
