package com.example.hello.controller;

import com.example.hello.dto.LikeResponse;
import com.example.hello.dto.post.PostCreateRequest;
import com.example.hello.dto.post.PostResponse;
import com.example.hello.dto.post.PostUpdateRequest;
import com.example.hello.entity.Post;
import com.example.hello.service.PostsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
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

    @PostMapping("/{id}/view")  // URL: /api/posts/128/view
    public ResponseEntity<PostResponse> getPostById(
            @PathVariable("id") Long id,
            @RequestParam("userId") Long userId
    ) {
        // 회원 정보가 x
        if(userId == null) {
            log.error("userId is null");
            Post post = postsService.findById(id);

            return ResponseEntity.ok(PostResponse.fromEntity(post));
        } else {
            Post post = postsService.findByIdAndUserId(id, userId);

            return ResponseEntity.ok(PostResponse.fromEntity(post));
        }

    }

    @GetMapping("/{id}")
    public ResponseEntity<PostResponse> getPostById(@PathVariable("id") Long id) {
        Post post = postsService.findById(id);
        return ResponseEntity.ok(PostResponse.fromEntity(post));
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

    @DeleteMapping("/{id}")
    public ResponseEntity<Post> delete(@PathVariable("id") Long postId) {
        postsService.deletePost(postId);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{id}/like")
    public ResponseEntity<LikeResponse> toggleLike(
            @PathVariable("id") Long postId,
            @RequestParam("userId") Long userId
    ) {
        return ResponseEntity.ok(postsService.toggleLike(postId, userId));
    }
}
