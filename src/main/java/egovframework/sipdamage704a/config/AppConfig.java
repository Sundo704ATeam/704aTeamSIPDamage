package egovframework.sipdamage704a.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class AppConfig implements WebMvcConfigurer { //Configuration 은 내부 @Configuration과 충돌남 -> AppConfig

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();	
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/forecast/**")
                .addResourceLocations("file:///C:/upload/forecast/")
                .setCachePeriod(3600);
    }
}