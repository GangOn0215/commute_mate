package com.example.hello.service;

import com.example.hello.dto.comment.PostCommentRequest;
import com.example.hello.entity.Post;
import com.example.hello.entity.PostComment;
import com.example.hello.entity.User;
import com.example.hello.repository.PostCommentRepository;
import com.example.hello.repository.PostsRepository;
import com.example.hello.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PostCommentService
{
    public final PostCommentRepository postCommentRepository;
    private final UserRepository userRepository;
    private final PostsRepository postsRepository;

    @Autowired
    public PostCommentService(PostCommentRepository postCommentRepository, UserRepository userRepository, PostsRepository postsRepository) {
        this.postCommentRepository = postCommentRepository;
        this.userRepository = userRepository;
        this.postsRepository = postsRepository;
    }

    public List<PostComment> getAllPostComments() {
        return postCommentRepository.findAll();
    }

    public List<PostComment> getByPostId(Long postId) {
        return postCommentRepository.findByPostIdWithUserAndPost(postId);
    }

    public PostComment create(PostCommentRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Post post = postsRepository.findById(request.getPostId())
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));

        PostComment comment = PostComment.builder()
                .user(user)
                .post(post)
                .content(request.getContent())
                .build();

        return postCommentRepository.save(comment);
    }
}