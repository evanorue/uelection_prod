package com.abadonapps.uelection.controller;

import com.abadonapps.uelection.model.User;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@RestController
@RequestMapping("/user")
@ControllerAdvice
public class UserController implements WebMvcConfigurer {

    @RequestMapping("/status")
    public String status() {
        return "Rest User Service is running...";
    }

    @RequestMapping("/add")
    public String add(@RequestBody User transaction) {
        return "Rest User Service is running...";
    }
}
