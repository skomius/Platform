package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

    /**
     * The main entry point for the Spring Boot application.
     * This method bootstraps and launches the DemoApplication using Spring Boot's
     * SpringApplication.run() method, which sets up default configuration, starts
     * the Spring ApplicationContext, and performs classpath scanning.
     *
     * @param args command-line arguments passed to the application, which can be
     *             used to override default configuration properties or provide
     *             runtime parameters
     */
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

}