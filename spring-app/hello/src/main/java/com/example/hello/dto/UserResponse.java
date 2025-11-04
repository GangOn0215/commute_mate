package com.example.hello.dto;

import com.example.hello.entity.User;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private Long id;
    private String userId;
    private String email;
    private String name;
    private String contact;
    private String nickname;

    public static UserResponse fromEntity(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .userId(user.getUserId())
                .email(user.getEmail())
                .name(user.getName())
                .contact(user.getContact())
                .nickname(user.getNickname())
                .build();
    }
}
