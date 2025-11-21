package com.example.hello.service;

import com.example.hello.dto.PostCreateRequest;
import com.example.hello.dto.PostUpdateRequest;
import com.example.hello.entity.Post;
import com.example.hello.entity.PostView;
import com.example.hello.entity.User;
import com.example.hello.repository.PostViewRepository;
import com.example.hello.repository.PostsRepository;
import com.example.hello.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.transaction.annotation.Propagation;


import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class PostsService {
    public final PostsRepository postRepository;
    private final UserRepository userRepository;
    private PostViewRepository postViewRepository;

    @Autowired
    public PostsService(PostsRepository postRepository, PostsRepository postsRepository, UserRepository userRepository, PostViewRepository postViewRepository) {
        this.postRepository = postsRepository;
        this.userRepository = userRepository;
        this.postViewRepository = postViewRepository;
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

    @Transactional(readOnly = true)
    public Post findByIdAndUserId(Long id, Long currentUserId) {
        Post post = postRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Post not found"));

        processViewCount(post, currentUserId);

        return post;
    }

    @Transactional(readOnly = true)
    protected void processViewCount(Post post, Long viewerId) {
        LocalDateTime oneDayAgo = LocalDateTime.now().minusDays(1);

        // 24시간 내 조회 이력
        boolean hasRecentView = postViewRepository.existsByPostIdAndUserIdAndViewedAtAfter(post.getId(), viewerId, oneDayAgo);

        if(!hasRecentView) {
            post.setReadCount(post.getReadCount() + 1);
            postRepository.save(post);

            updateViewHistoryAsync(post.getId(), viewerId);
        }
    }

    @Async
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    protected void updateViewHistoryAsync(Long postId, Long viewerId) {
        PostView newView = new PostView();
        newView.setPost(postRepository.findById(postId).orElseThrow());
        newView.setUser(userRepository.findById(viewerId).orElseThrow());
        newView.setViewedAt(LocalDateTime.now());
        postViewRepository.save(newView);
    }
    // 삭제
    public void deletePost(Long postId) {
        postRepository.deleteById(postId);
    }
}
