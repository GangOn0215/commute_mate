package com.example.hello.dto.comment;

import com.example.hello.entity.PostComment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PostCommentResponse {
    private Long id;
    private UserInfo user;
    private Long parentId;
    private String content;
    private Integer likeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<PostCommentResponse> replies;

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

    public static PostCommentResponse fromEntity(PostComment c) {
        // 삭제된 댓글은 내용 마스킹
        String content = c.getDeletedAt() != null ? "삭제된 댓글입니다." : c.getContent();

        List<PostCommentResponse> replyList = (c.getReplies() != null)
                ? c.getReplies().stream()
                    .map(PostCommentResponse::fromEntity)
                    .collect(Collectors.toList())
                : List.of();

        return PostCommentResponse.builder()
                .id(c.getId())
                .user(c.getUser() != null ? UserInfo.builder()
                        .id(c.getUser().getId())
                        .userId(c.getUser().getUserId())
                        .name(c.getUser().getName())
                        .nickname(c.getUser().getNickname())
                        .profileImageUrl(c.getUser().getProfileImageUrl())
                        .build() : null)
                .parentId(c.getParent() != null ? c.getParent().getId() : null)
                .content(content)
                .likeCount(c.getLikeCount())
                .createdAt(c.getCreatedAt())
                .updatedAt(c.getUpdatedAt())
                .replies(replyList)
                .build();
    }
}
