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
	
	private String safetyIns_code;
	private String ufid;
	private String gid;
	private String crack_ins;
	private String elecleakage_ins;
	private String leakage_ins;
	private String deformation_ins;
	private String anomaly_ins;
	private int crack_cnt;
	private int elecleakage_cnt;
	private int leakage_cnt;
	private int deformation_cnt;
	private int anomaly_cnt;
	private String inspector;
	private LocalDate ins_date;
	
	
}
