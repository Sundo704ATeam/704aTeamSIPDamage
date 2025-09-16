package egovframework.sipdamage704a.dto.damage;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Damage_InspectDto {
	
	private int inscode;
	private int managecode;

	private String crackrate;
	private int crackcnt;
	
	private String elecleakrate;
	private int elecleakcnt;
	
	private String leakrate;
	private int leakcnt;
	
	private String variationrate;
	private int variationcnt;
	
	private String abnomalityrate;
	private int abnomalitycnt;
	
	private LocalDate ins_date;
	private String inspactor;
}
