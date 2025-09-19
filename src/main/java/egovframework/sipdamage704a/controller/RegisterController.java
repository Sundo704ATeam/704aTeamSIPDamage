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
	        @RequestParam(required = false) String x,
	        @RequestParam(required = false) String y,
	        Model model) {

	    if (x != null && y != null) {
	        // x,y 있을 때만 주소 변환
	        AddressDto addressDto = addressService.getlonlatpoint(x, y);
	        addressDto = addressService.getAddressDetail(addressDto);

	        model.addAttribute("address", addressDto.getPointAddress());
	        model.addAttribute("x", x);
	        model.addAttribute("y", y);
	    }

	    // 좌표 없으면 그냥 빈 폼 열림
	    return "sj/registerPage";
	}

	@PostMapping("/saveBuilding")
	public String saveBuilding(StructureDto dto, Model model) {
	    structureService.registerStructure(dto);
	    model.addAttribute("success", true); 
	    return "sj/registerPage"; 
	}


}