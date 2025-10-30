package com.example.hello.entity;

import com.example.hello.common.enums.PostsCategory;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name="app_posts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Posts {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    private User user;
    @Column(nullable = false)
    private String title;
    @Lob  // TEXT 타입으로 매핑
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PostsCategory category;
    @Column(nullable = false)
    @Builder.Default()
    private Integer likeCount = 0;
    @Column(nullable = false)
    @Builder.Default()
    private Integer commentCount = 0;
    @Column(nullable = false)
    @Builder.Default()
    private Integer readCount = 0;
    @CreatedDate
    @Column(nullable = false)
    private LocalDateTime createdAt;
    @LastModifiedDate
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
    @Builder.Default()
    private Boolean isActive = true;
}
