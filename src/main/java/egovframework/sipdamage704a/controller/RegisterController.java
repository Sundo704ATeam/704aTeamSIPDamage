package egovframework.sipdamage704a.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.sipdamage704a.dto.address.AddressDto;
import egovframework.sipdamage704a.dto.damage.StructureDto;
import egovframework.sipdamage704a.service.AddressService;
import egovframework.sipdamage704a.service.StructureService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sj")
public class RegisterController {

	private final AddressService addressService; 
	private final StructureService structureService;
	
	@GetMapping("/registerPage")
	public String registerPage(
	        @RequestParam String x,  // ← 문자열로 받음
	        @RequestParam String y,
	        Model model) {

		// x,y좌표 => 위도경도 변환 
		AddressDto addressDto = addressService.getlonlatpoint(x, y);
		System.out.println("addressDto => " + addressDto.getLon() + " / " + addressDto.getLat() );
	
		addressDto = addressService.getAddressDetail(addressDto);
		
		
		
		model.addAttribute("address", addressDto.getPointAddress());
	    model.addAttribute("x", x);
	    model.addAttribute("y", y);
	    return "sj/registerPage";
	}
	
    @PostMapping("/saveBuilding")
    public String saveBuilding(StructureDto dto) {
        structureService.registerStructure(dto);
        return "sj/structureList"; 
    }
}