package com.example.hello.dto;

import com.example.hello.common.enums.PostsCategory;
import lombok.Data;

@Data
public class PostCommentRequest {
    private Long userId;
    private Long postId;
    private String title;
    private String content;
    private PostsCategory category;
}
