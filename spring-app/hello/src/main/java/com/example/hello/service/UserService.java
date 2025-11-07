package com.example.hello.service;

import com.example.hello.dto.UploadResponse;
import com.example.hello.entity.User;
import com.example.hello.repository.UserRepository;
import jdk.jfr.TransitionFrom;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository repo;
    private final UserRepository userRepository;
    private final FileStorageService fileStorageService;

    public User signup(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user = repo.save(user);

        return user;
    }

    public User login(User user) {
        User found = repo.findByUserId(user.getUserId()).orElse(null);

        if(found == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Not Found Account.");
        }

        if(!passwordEncoder.matches(user.getPassword(), found.getPassword())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "This is the wrong password.");
        }

        // 패스워드 변환
        return found;
    }

    public UploadResponse uploadProfileImage(Long userId, MultipartFile file) {
        validateImageFile(file);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        if(user.getProfileImageUrl() != null) {
            fileStorageService.deleteFile(user.getProfileImageUrl());
        }

        String imageUrl = fileStorageService.storeFile(file, "profiles");

        user.setProfileImageUrl(imageUrl);
        userRepository.save(user);

        return new UploadResponse(
          "이미지 업로드 성공",
          imageUrl,
          file.getSize()
        );
    }

    private void validateImageFile(MultipartFile file) {
        if(file.isEmpty()) {
            throw new IllegalArgumentException("파일이 비었습니다.");
        }

        String contentType = file.getContentType();
        if(contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("이미지 파일만 업로드 가능합니다.");
        }
    }

    public List<User> getAll() {
        return repo.findAll();
    }

    public User create(User user) {
        return repo.save(user);
    }

    public User getById(Long id) {
        return repo.findById(id).orElse(null);
    }

    public void deleteById(Long id) {
        repo.deleteById(id);
    }
}
