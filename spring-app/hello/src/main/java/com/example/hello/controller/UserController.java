package com.example.hello.controller;

import com.example.hello.entity.User;
import com.example.hello.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

        import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final UserService service;

    @Autowired
    public UserController(UserService service) {
        this.service = service;
    }
    @GetMapping
    public List<User> getAll() {
        return service.getAll();
    }

    @PostMapping("/{id}")
    public User getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @PostMapping
    public User create(@RequestBody User user) {
        return service.create(user);
    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable Long id) {
        service.deleteById(id);
        return "success";
    }
}
