package com.example.hello.repository;

import com.example.hello.entity.Posts;
import com.example.hello.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostsRepository extends JpaRepository<Posts, Long> {
    @Query("SELECT p FROM Posts p JOIN FETCH p.user ORDER BY p.createdAt DESC")
    List<Posts> findAllWithUser();
}
