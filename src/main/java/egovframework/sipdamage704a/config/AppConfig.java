package egovframework.sipdamage704a.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig { //Configuration 은 내부 @Configuration과 충돌남 -> AppConfig
	
	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();	
	}
	

}
