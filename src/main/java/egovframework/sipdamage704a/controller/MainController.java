package egovframework.sipdamage704a.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import egovframework.sipdamage704a.service.DamageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final DamageService damageService;

    // 메인 페이지
    @GetMapping("/")
    public String mainPage(Model model) {
        System.out.println("====================== START ======================");
        return "main";  
    }

    @GetMapping("/risk/top5/crack")
    @ResponseBody
    public List<Map<String,Object>> getTop5Crack() {
        return damageService.findTop5Crack();
    }
    @GetMapping("/risk/top5/elecleak")
    @ResponseBody
    public List<Map<String,Object>> getTop5elecleak() {
        return damageService.findTop5eleleak();
    }
    @GetMapping("/risk/top5/leak")
    @ResponseBody
    public List<Map<String,Object>> getTop5leak() {
        return damageService.findTop5leak();
    }
    @GetMapping("/risk/top5/variation")
    @ResponseBody
    public List<Map<String,Object>> getTop5variation() {
        return damageService.findTop5variation();
    }
    @GetMapping("/risk/top5/abnormality")
    @ResponseBody
    public List<Map<String,Object>> getTop5abnormality() {
        return damageService.findTop5abnoramlity();
    }



    
}
