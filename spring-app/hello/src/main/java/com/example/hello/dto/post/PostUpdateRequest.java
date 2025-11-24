package com.example.hello.dto.post;


import com.example.hello.common.enums.PostsCategory;
import lombok.Data;

@Data
public class PostUpdateRequest  {
    private String title;
    private String content;
    private PostsCategory category;
}
