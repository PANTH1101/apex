package com.eventmanagement.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

/**
 * Serves the local uploads directory as static HTTP resources.
 *
 * An image stored at  uploads/events/abc.jpg
 * becomes accessible at  http://localhost:8080/uploads/events/abc.jpg
 *
 * On Android emulator:  http://10.0.2.2:8080/uploads/events/abc.jpg
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Resolve to an absolute file:// URI so Spring can find it regardless
        // of the working directory.
        String absolutePath = Paths.get(uploadDir).toAbsolutePath().normalize().toUri().toString();
        if (!absolutePath.endsWith("/")) {
            absolutePath = absolutePath + "/";
        }

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(absolutePath);
    }
}
