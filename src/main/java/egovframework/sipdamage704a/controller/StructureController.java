package egovframework.sipdamage704a.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import egovframework.sipdamage704a.dto.damage.StructureDto;
import egovframework.sipdamage704a.service.StructureService;

@Controller
public class StructureController {

    @Autowired
    private StructureService structureService;

    // 전체 조회 페이지 이동
    @GetMapping("/StructureList")
    public String getAllStructures(Model model) {
        model.addAttribute("structures", structureService.getAllStructures());
        return "sj/StructureList";  
    }

    // managecode 상세 페이지 이동
    @GetMapping("/StructureDetail")
    public String getStructureByManagecode(@RequestParam("managecode") String managecode, Model model) {
        StructureDto dto = structureService.getStructureByManagecode(managecode);
        model.addAttribute("structure", dto);
        return "StructureDetail"; 
    }
}
