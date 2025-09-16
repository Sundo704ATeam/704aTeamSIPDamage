package egovframework.sipdamage704a;

import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

import egovframework.sipdamage704a.service.RainfallService;

@SpringBootApplication
@EnableScheduling
@EnableAsync
public class EgovBootApplication extends SpringBootServletInitializer {
	
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(EgovBootApplication.class);
    }

	public static void main(String[] args) {
		SpringApplication.run(EgovBootApplication.class, args);
	}

	/*
    @Bean
    ApplicationRunner startup(RainfallService rainfall) {
		return args -> {
			rainfall.saveRainfallsUntilNow();
		};
	}
	*/
}