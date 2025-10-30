package com.example.hello.dto;

import com.example.hello.common.enums.PostsCategory;
import lombok.Data;

@Data
public class PostCreateRequest {
    private Long userId;
    private String title;
    private String content;
    private PostsCategory category;
}
