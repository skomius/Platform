package com.example.demo;

import org.springframework.web.bind.annotation.*;

@RestController
public class HelloController {

    /**
     * Handles HTTP GET requests to the root endpoint ("/").
     * 
     * @return a greeting message string indicating the application is running on Spring Boot and Minikube
     */
    @GetMapping("/")
    public String hello() {
        return "Hello from Spring Boot on Minikube!";
    }
}