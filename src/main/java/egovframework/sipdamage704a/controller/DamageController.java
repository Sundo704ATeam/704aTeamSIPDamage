package egovframework.sipdamage704a.controller;


import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
import egovframework.sipdamage704a.service.StructureService;
import egovframework.sipdamage704a.util.CustomFileUtil;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/damageMap")
public class DamageController {

	private final DamageService damageService;
	private final CustomFileUtil fileUtil;
	private final StructureService structureService;
	
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
	
	@GetMapping("/inspect/excelDownload")
	public void excelDownload(@RequestParam("managecode") int managecode, HttpServletResponse response) throws IOException {
	    // ✅ 서비스에서 점검내역 가져오기
	    List<Damage_InspectDto> list = structureService.getInspectsByManagecode(managecode);

	    // ✅ Workbook / Sheet 생성
	    Workbook wb = new XSSFWorkbook();
	    Sheet sheet = wb.createSheet("점검내역");

	    // ✅ 헤더 스타일
	    CellStyle headerStyle = wb.createCellStyle();
	    Font headerFont = wb.createFont();
	    headerFont.setBold(true);
	    headerStyle.setFont(headerFont);
	    headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    // ✅ 헤더 행
	    String[] headers = {
	        "점검일", "점검자",
	        "균열(개수/등급)", "누전(개수/등급)",
	        "누수(개수/등급)", "변형(개수/등급)",
	        "구조이상(개수/등급)"
	    };

	    Row headerRow = sheet.createRow(0);
	    for (int i = 0; i < headers.length; i++) {
	        Cell cell = headerRow.createCell(i);
	        cell.setCellValue(headers[i]);
	        cell.setCellStyle(headerStyle);
	    }

	    // ✅ 데이터 행
	    int rowNum = 1;
	    for (Damage_InspectDto dto : list) {
	        Row row = sheet.createRow(rowNum++);
	        row.createCell(0).setCellValue(dto.getIns_date().toString()); // 점검일
	        row.createCell(1).setCellValue(dto.getInspactor());           // 점검자
	        row.createCell(2).setCellValue(dto.getCrackcnt() + "[" + dto.getCrack_grade() + "]");
	        row.createCell(3).setCellValue(dto.getElecleakcnt() + "[" + dto.getElecleak_grade() + "]");
	        row.createCell(4).setCellValue(dto.getLeakcnt() + "[" + dto.getLeak_grade() + "]");
	        row.createCell(5).setCellValue(dto.getVariationcnt() + "[" + dto.getVariation_grade() + "]");
	        row.createCell(6).setCellValue(dto.getAbnormalitycnt() + "[" + dto.getAbnormality_grade() + "]");
	    }

	    // ✅ 컬럼 폭 자동 조정
	    int minWidth = 4000; // 최소 14자
	    for (int i = 0; i < headers.length; i++) {
	        sheet.autoSizeColumn(i);
	        if (sheet.getColumnWidth(i) < minWidth) {
	            sheet.setColumnWidth(i, minWidth);
	        } else {
	            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 512);
	        }
	    }

	    // ✅ 응답 헤더
	    response.setHeader(
	    	    "Content-Disposition",
	    	    "attachment; filename=inspect_list_" + managecode + ".xlsx"
	    	);
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    

	    // ✅ 파일 쓰기
	    wb.write(response.getOutputStream());
	    wb.close();
	}
	
}