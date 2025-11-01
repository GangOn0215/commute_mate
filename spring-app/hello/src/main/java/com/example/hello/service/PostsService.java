package com.example.hello.service;

import com.example.hello.dto.PostCreateRequest;
import com.example.hello.dto.PostResponse;
import com.example.hello.entity.User;
import com.example.hello.repository.PostsRepository;
import com.example.hello.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostsService {
    public final PostsRepository postRepository;
    private final UserRepository userRepository;

    @Autowired
    public PostsService(PostsRepository postRepository, PostsRepository postsRepository, UserRepository userRepository) {
        this.postRepository = postsRepository;
        this.userRepository = userRepository;
    }

    public List<Post> getAll() {
        return postRepository.findAll();
    }

    public List<Post> getAllPosts() {
        return postRepository.findAllWithUser();
    }

    public Post create(PostCreateRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Post post = Post.builder()
                .user(user)
                .title(request.getTitle())
                .content(request.getContent())
                .category(request.getCategory())
                .createdAt(LocalDateTime.now())   // ✅ 임시
                .updatedAt(LocalDateTime.now())   // ✅ 임시
                .build();

        return postRepository.save(post);
    }

    public Posts update(Posts posts) {
        return postRepository.save(posts);
    }

    public Posts findById(Long id) {
        return postRepository.findById(id).get();
    }
}
