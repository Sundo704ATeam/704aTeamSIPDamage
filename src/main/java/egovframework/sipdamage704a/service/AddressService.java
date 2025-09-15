package egovframework.sipdamage704a.service;

import java.util.List;
import java.util.Map;

import egovframework.sipdamage704a.dto.address.AddressDto;

public interface AddressService {

	AddressDto getlonlatpoint(String x, String y);

	AddressDto getAddressDetail(AddressDto addressDto);

	

}
