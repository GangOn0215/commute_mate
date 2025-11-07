package com.example.hello.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UploadResponse {
    private String message;
    private String fileUrl;
    private long fileSize;
}
