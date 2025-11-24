package com.example.hello.dto.comment;

import com.example.hello.entity.Post;
import com.example.hello.entity.PostComment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PostCommentResponse {
    private Long id;
    private UserInfo user;  // 중첩 DTO
    private Post post;
    private String content;
    private Integer likeCount;
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
        private String profileImageUrl;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PostInfo {
        private Long id;

    }

    public static PostCommentResponse fromEntity(PostComment postComment) {
        return PostCommentResponse.builder()
                .id(postComment.getId())
                .user(UserInfo.builder()
                        .id(postComment.getUser().getId())
                        .userId(postComment.getUser().getUserId())
                        .name(postComment.getUser().getName())
                        .nickname(postComment.getUser().getNickname())
                        .profileImageUrl(postComment.getUser().getProfileImageUrl())
                        .build())
                .content(postComment.getContent())
                .likeCount(postComment.getLikeCount())
                .createdAt(postComment.getCreatedAt())
                .updatedAt(postComment.getUpdatedAt())
                .build();
    }
}