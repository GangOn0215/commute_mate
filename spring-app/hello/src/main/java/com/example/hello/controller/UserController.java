package com.example.hello.controller;

import com.example.hello.dto.UploadResponse;
import com.example.hello.dto.UserResponse;
import com.example.hello.entity.User;
import com.example.hello.service.UserService;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/user")
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

    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@RequestBody User user) {
        User getUser = service.login(user);

        return ResponseEntity.ok(UserResponse.fromEntity(getUser));
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

    // 이미지 업로드
    @PostMapping("/{userId}/profile_image")
    public ResponseEntity<?> uploadProfileImage(@PathVariable Long userId, @RequestParam("image") MultipartFile file) {
        try {
            UploadResponse response = service.uploadProfileImage(userId, file);
            return ResponseEntity.ok(response);
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest()
                    .body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body("업로드 실패: " + e.getMessage());
        }

    }

    @DeleteMapping("/{id}")
    public String deleteById(@PathVariable Long id) {
        service.deleteById(id);
        return "success";
    }
}
