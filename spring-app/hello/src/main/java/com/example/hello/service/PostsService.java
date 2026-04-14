package com.example.hello.service;

import com.example.hello.dto.LikeResponse;
import com.example.hello.dto.post.PostCreateRequest;
import com.example.hello.dto.post.PostResponse;
import com.example.hello.dto.post.PostUpdateRequest;
import com.example.hello.entity.Post;
import com.example.hello.entity.PostLike;
import com.example.hello.entity.PostView;
import com.example.hello.entity.User;
import com.example.hello.repository.PostCommentRepository;
import com.example.hello.repository.PostLikeRepository;
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
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class PostsService {
    public final PostsRepository postRepository;
    private final UserRepository userRepository;
    private PostViewRepository postViewRepository;
    private PostCommentRepository postCommentRepository;
    private PostLikeRepository postLikeRepository;

    @Autowired
    public PostsService(PostsRepository postRepository, PostsRepository postsRepository, UserRepository userRepository, PostViewRepository postViewRepository, PostCommentRepository postCommentRepository, PostLikeRepository postLikeRepository) {
        this.postRepository = postsRepository;
        this.userRepository = userRepository;
        this.postViewRepository = postViewRepository;
        this.postCommentRepository = postCommentRepository;
        this.postLikeRepository = postLikeRepository;
    }

    public List<PostResponse> getPosts() {
        List<Post> posts = postRepository.findAll();

        return posts.stream()
                .map(post -> {
                    Integer actualCommentCount = postCommentRepository.countByPostIdAndDeletedAtIsNull(post.getId());
                    return PostResponse.fromEntity(post, actualCommentCount);
                })
                .collect(Collectors.toList());
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

    // 게시글 좋아요 토글
    public LikeResponse toggleLike(Long postId, Long userId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        boolean alreadyLiked = postLikeRepository.existsByPostIdAndUserId(postId, userId);

        if (alreadyLiked) {
            postLikeRepository.findByPostIdAndUserId(postId, userId)
                    .ifPresent(postLikeRepository::delete);
            post.setLikeCount(Math.max(0, post.getLikeCount() - 1));
        } else {
            postLikeRepository.save(PostLike.builder().post(post).user(user).build());
            post.setLikeCount(post.getLikeCount() + 1);
        }

        postRepository.save(post);
        return new LikeResponse(post.getLikeCount(), !alreadyLiked);
    }
}
