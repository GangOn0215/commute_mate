package com.example.hello.controller;

import com.example.hello.dto.PostCreateRequest;
import com.example.hello.dto.PostResponse;
import com.example.hello.dto.PostUpdateRequest;
import com.example.hello.entity.Post;
import com.example.hello.service.PostsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/posts")
public class PostsController {
    private final PostsService postsService;

    @Autowired
    public PostsController(PostsService postsService) {
        this.postsService = postsService;
    }

    @GetMapping
    public ResponseEntity<List<PostResponse>> getAllPosts() {
        List<Post> posts = postsService.getAllPosts();

        // ✅ Entity -> DTO 변환
        List<PostResponse> response = posts.stream()
                .map(PostResponse::fromEntity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<PostResponse> create(@RequestBody PostCreateRequest posts) {
        Post created = postsService.create(posts);
        return ResponseEntity.ok(PostResponse.fromEntity(created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PostResponse> update(@PathVariable("id") Long postId, @RequestBody PostUpdateRequest newPost) {
        Post updated = postsService.updatePost(postId, newPost);

        return ResponseEntity.ok(PostResponse.fromEntity(updated));
    }
}
