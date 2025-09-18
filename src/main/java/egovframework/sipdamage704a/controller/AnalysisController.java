package egovframework.sipdamage704a.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.sipdamage704a.service.DamageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/analysis")
public class AnalysisController {

    private final DamageService damageService;

    // 분석 메인 페이지
    @GetMapping("view")
    public String analysisView() {
        return "sj/analysis"; 
    }

    // 손상 이력 조회
    @GetMapping("/stats/history")
    @ResponseBody
    public List<Map<String, Object>> getDamageHistory(@RequestParam int managecode) {
        return damageService.getDamageHistory(managecode);
    }

}
