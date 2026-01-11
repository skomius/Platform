package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

@RestController
public class HelloController {

    private static final Logger log = LoggerFactory.getLogger(HelloController.class);

    /**
     * Handles HTTP GET requests to the root endpoint ("/").
     * 
     * @return a greeting message string indicating the application is running on Spring Boot and Minikube
     */
    @GetMapping("/")
    public String hello() {
        log.info("Hello endpoint was called");
        return "Hello from Spring Boot on Minikube!";
    }
}