package egovframework.sipdamage704a.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

import lombok.RequiredArgsConstructor;
import egovframework.sipdamage704a.service.DamageService;
import egovframework.sipdamage704a.dto.damage.bridgeDto;

@Controller
@RequiredArgsConstructor
public class DamageDetailController {

    private final DamageService damageService;

    @GetMapping("/bridge/detail")
    public String bridgeDetail(@RequestParam("ufid") String ufid, Model model) {
        bridgeDto bridge = damageService.getBridge(ufid);
        model.addAttribute("bridge", bridge);

        return "sj/layersDetail/bridgeDetail";
    }
}
