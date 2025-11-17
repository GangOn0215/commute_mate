package com.example.hello.repository;

import com.example.hello.entity.PostView;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.Optional;

public interface PostViewRepository extends JpaRepository<PostView, Long> {
    boolean existsByPostIdAndUserIdAndViewedAtAfter(Long postId, Long userId, LocalDateTime viewedAt);

    Optional<PostView> findByPostIdAndUserId(Long postId, Long userId);
}
