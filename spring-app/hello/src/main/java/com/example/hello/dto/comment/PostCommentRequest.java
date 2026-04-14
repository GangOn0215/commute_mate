package com.example.hello.dto.comment;

import lombok.Data;

@Data
public class PostCommentRequest {
    private Long userId;
    private Long postId;
    private Long parentId;  // null = 일반 댓글, 값 있음 = 대댓글
    private String content;
}
