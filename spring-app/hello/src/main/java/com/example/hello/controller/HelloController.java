package com.example.hello.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/")
    public String home() {
        System.out.println("DB_USER = " + System.getenv("DB_USER"));

        return "서버가 정상적으로 진행 중";
    }

    @GetMapping("/api/hello")
    public String hello() {
        return "hello, Spring Boot Rest Api!";
    }
}
