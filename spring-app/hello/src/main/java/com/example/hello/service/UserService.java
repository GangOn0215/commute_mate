package com.example.hello.service;

import com.example.hello.entity.User;
import com.example.hello.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository repo;

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
