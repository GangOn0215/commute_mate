package com.example.hello.repository;

import com.example.hello.entity.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostsRepository extends JpaRepository<Post, Long> {
    @Query("SELECT p FROM Post p JOIN FETCH p.user ORDER BY p.createdAt DESC")
    List<Post> findAllWithUser();
}
