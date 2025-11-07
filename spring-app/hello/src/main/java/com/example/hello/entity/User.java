package com.example.hello.entity;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name="user")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class User {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    private String userId;
    private String password;
    private String email;
    private String name;
    private String contact;
    private String nickname;

    private Integer level;
    private boolean isActive;

    private String profileImageUrl;

    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;
}
