package egovframework.sipdamage704a.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.sipdamage704a.dto.damage.DamageImgDto;
import egovframework.sipdamage704a.dto.damage.Damage_InspectDto;
import egovframework.sipdamage704a.service.DamageService;
import egovframework.sipdamage704a.util.CustomFileUtil;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/damageMap")
public class DamageController {

	private final DamageService damageService;
	private final CustomFileUtil fileUtil;
	
	@GetMapping("")
	public String damageMap() {
		
		return "sj/damageMap";
	}
	
	
	@GetMapping("/inspect/new")
	public String inspectNewPage(@RequestParam("managecode") int managecode, Model model) {
		model.addAttribute("managecode", managecode);
		return "sj/inspectPage";
	}
	
	
	@PostMapping("/inspect/save")
	@ResponseBody
	public Map<String, Object> inspectSave(
	        @ModelAttribute Damage_InspectDto dto,
	        @RequestParam Map<String, String> imgLocMap, // 위치 정보
	        @RequestParam MultiValueMap<String, MultipartFile> fileMap // 파일 정보
	) {
	    System.out.println("===== 업로드 요청 디버깅 =====");
	    System.out.println("Damage_InspectDto => " + dto);
	    System.out.println("imgLocMap => " + imgLocMap);
	    System.out.println("fileMap keys => " + fileMap.keySet());

	    Map<String, Object> res = new HashMap<>();

	    try {
	        int result = damageService.saveInspect(dto);
	        
	        // 등록된 inscode 가져오기
	        Map<String, Object> getinscode = damageService.findLatestByUfid(dto.getManagecode());
	        int inscode = (int) getinscode.get("inscode");
	        
	        
	        if (result > 0) {
	            for (String key : imgLocMap.keySet()) {
	                if (!key.startsWith("img_loc[")) continue; // 관리번호, 날짜 등은 스킵

	                String loc = imgLocMap.get(key);
	                String index = key.substring(key.indexOf("[") + 1, key.indexOf("]")); // 0,1,2...

	                // files[n] 꺼내오기
	                List<MultipartFile> fileList = fileMap.get("files[" + index + "]");

	                System.out.println("현재 처리중 index=" + index);
	                System.out.println("위치 => " + loc);
	                if (fileList != null) {
	                    for (MultipartFile mf : fileList) {
	                        System.out.println("파일명 => " + mf.getOriginalFilename());
	                    }
	                }

	                if (fileList != null && !fileList.isEmpty()) {
	                    List<String> savedNames = fileUtil.saveFiles(fileList);
	                    for (String fileName : savedNames) {
	                        DamageImgDto imgDto = new DamageImgDto();
	                        imgDto.setInscode(inscode);
	                        imgDto.setManagecode(dto.getManagecode());
	                        imgDto.setImg_loc(loc);
	                        imgDto.setFilename(fileName);

	                        damageService.saveDamageImg(imgDto);
	                    }
	                }
	            }
	        }

	        res.put("success", true);
	    } catch (Exception e) {
	        e.printStackTrace();
	        res.put("success", false);
	    }

	    return res;
	}
	
	@GetMapping("/inspect/detail")
	public String inspectDetail(@RequestParam("inscode") int inscode ,Model model) {
		
		Damage_InspectDto inspectDto = damageService.getFindByInscode(inscode);
	    List<DamageImgDto> imgList = damageService.getImagesByInscode(inscode);

	    System.out.println("===== Inspect Detail Debug =====");
	    System.out.println("inscode => " + inscode);
	    System.out.println("inspectDto => " + inspectDto);
	    System.out.println("imgList size => " + (imgList != null ? imgList.size() : 0));
	    
	    // 위치별 그룹핑
	    Map<String, List<String>> imgMap = new LinkedHashMap<>();
	    for (DamageImgDto img : imgList) {
	        imgMap.computeIfAbsent(img.getImg_loc(), k -> new ArrayList<>())
	              .add(img.getFilename());
	        System.out.println("imgDto => loc=" + img.getImg_loc() + ", file=" + img.getFilename());
	    }

	    System.out.println("imgMap => " + imgMap);
	    
	    model.addAttribute("damage_InspectDto", inspectDto);
	    model.addAttribute("imgMap", imgMap);
	    return "sh/inspectDetail";
	}
	
	@GetMapping("/files/{fileName:.+}")
	@ResponseBody
	public ResponseEntity<Resource> loadFile(@PathVariable("fileName") String fileName) {
	    System.out.println("파일 요청 => " + fileName);
	    ResponseEntity<Resource> res = fileUtil.getFile(fileName);
	    System.out.println("응답 상태 => " + res.getStatusCode());
	    return res;
	}
	
}