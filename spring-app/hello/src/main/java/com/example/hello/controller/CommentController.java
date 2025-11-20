package com.example.hello.controller;

import com.example.hello.dto.PostCommentRequest;
import com.example.hello.dto.PostCommentResponse;
import com.example.hello.dto.PostCreateRequest;
import com.example.hello.dto.PostResponse;
import com.example.hello.entity.Post;
import com.example.hello.entity.PostComment;
import com.example.hello.service.PostCommentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/posts_comments")
public class CommentController {
    private final PostCommentService postCommentService;

    public CommentController(PostCommentService postCommentService) {
        this.postCommentService = postCommentService;
    }

    @GetMapping("/all")
    public ResponseEntity<List<PostCommentResponse>> getAll() {
        List<PostComment> postComments = postCommentService.getAllPostComments();

        List<PostCommentResponse> response = postComments.stream()
                .map(PostCommentResponse::fromEntity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<PostCommentResponse> create(@RequestBody PostCommentRequest comments) {
        PostComment created = postCommentService.create(comments);
        return ResponseEntity.ok(PostCommentResponse.fromEntity(created));
    }



}

