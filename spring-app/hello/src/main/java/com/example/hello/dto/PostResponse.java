package com.example.hello.dto;

import com.example.hello.entity.Post;
import com.example.hello.common.enums.PostsCategory;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PostResponse {
    private Long id;
    private UserInfo user;  // 중첩 DTO
    private String title;
    private String content;
    private PostsCategory category;
    private Integer likeCount;
    private Integer commentCount;
    private Integer readCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserInfo {
        private Long id;
        private String userId;
        private String name;
        private String nickname;
    }

    public static PostResponse fromEntity(Post post) {
        return PostResponse.builder()
                .id(post.getId())
                .user(UserInfo.builder()
                        .id(post.getUser().getId())
                        .userId(post.getUser().getUserId())
                        .name(post.getUser().getName())
                        .nickname(post.getUser().getNickname())
                        .build())
                .title(post.getTitle())
                .content(post.getContent())
                .category(post.getCategory())
                .likeCount(post.getLikeCount())
                .commentCount(post.getCommentCount())
                .readCount(post.getReadCount())
                .createdAt(post.getCreatedAt())
                .updatedAt(post.getUpdatedAt())
                .build();
    }
}