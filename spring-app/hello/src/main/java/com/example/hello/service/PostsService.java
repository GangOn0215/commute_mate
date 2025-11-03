package com.example.hello.service;

import com.example.hello.dto.PostCreateRequest;
import com.example.hello.dto.PostResponse;
import com.example.hello.dto.PostUpdateRequest;
import com.example.hello.entity.Post;
import com.example.hello.entity.User;
import com.example.hello.repository.PostsRepository;
import com.example.hello.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
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
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return postRepository.save(post);
    }

    public Post updatePost(Long postId, PostUpdateRequest newPosts) {
        // 데이터를 가져오자
        Post oldPost = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));

        oldPost.setTitle(newPosts.getTitle());
        oldPost.setContent(newPosts.getContent());
        oldPost.setCategory(newPosts.getCategory());
        // 여기서 DB 적용이 x
        return oldPost;
        // 이 시점에서 DB 적용
    }

    public Post findById(Long id) {
        return postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
    }

    // 삭제
    public void deletePost(Long postId) {
        postRepository.deleteById(postId);
    }
}
