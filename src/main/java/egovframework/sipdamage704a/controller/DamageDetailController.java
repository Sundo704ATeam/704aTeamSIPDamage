package egovframework.sipdamage704a.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

import lombok.RequiredArgsConstructor;
import egovframework.sipdamage704a.service.DamageService;
import egovframework.sipdamage704a.dto.damage.BridgeDto;
import egovframework.sipdamage704a.dto.damage.FootBridgeDto;
import egovframework.sipdamage704a.dto.damage.TunnelDto;

@Controller
@RequiredArgsConstructor
public class DamageDetailController {

    private final DamageService damageService;

    @GetMapping("/bridge/detail")
    public String bridgeDetail(@RequestParam("ufid") String ufid, Model model) {
        BridgeDto bridge = damageService.getBridge(ufid);
        model.addAttribute("bridge", bridge);

        return "sj/layersDetail/bridgeDetail";
    }
    
    @GetMapping("/footbridge/detail")
    public String footbridgeDetail(@RequestParam("ufid") String ufid, Model model) {
        FootBridgeDto footbridge = damageService.getFootBridge(ufid);
        model.addAttribute("footbridge", footbridge);

        return "sj/layersDetail/footbridgeDetail";
    }
    
    @GetMapping("/tunnel/detail")
    public String tunnelDetail(@RequestParam("ufid") String ufid, Model model) {
        TunnelDto tunnel = damageService.getTunnel(ufid);
        model.addAttribute("Tunnel", tunnel);

        return "sj/layersDetail/tunnelDetail";
    }
}
