package com.example.hello.controller;

import com.example.hello.dto.UserResponse;
import com.example.hello.entity.User;
import com.example.hello.service.UserService;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    @PostMapping("/signup")
    public ResponseEntity<UserResponse> signup(@RequestBody User user) {
        User newUser = service.signup(user);

        return ResponseEntity.ok(UserResponse.fromEntity(newUser));
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
