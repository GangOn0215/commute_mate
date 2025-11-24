package com.example.hello.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name="app_posts_comments")
public class PostComment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id", nullable = false)
    private Post post;

    @Column(name="root_id")
    private Long rootId;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    @Column(name="like_count")
    private Integer likeCount;

    @Column(name="created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name="updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist // 생성 직후 자동으로 아래 함수를 호출시킨다
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    @PreUpdate // 업데이트 직후 자동으로 아래 함수를 호출시킨다
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
