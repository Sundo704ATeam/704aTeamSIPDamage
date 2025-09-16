package egovframework.sipdamage704a.dto.damage;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class StructureDto {
	private int managecode;
	private String type;
	private String name;
	private String address;
	private double x;
	private double y;
	private String sort;
	private int hoshi;
	private String materials;

	
	
}
