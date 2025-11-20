package com.example.hello.repository;

import com.example.hello.entity.PostComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface PostCommentRepository extends JpaRepository<PostComment, Long> {
    // 댓글, 최신순으로 정렬해서 모두 가져오기

    List<PostComment> findByPostIdOrderByCreatedAtDesc(Long postId);

    @Query("SELECT c FROM PostComment c " +
            "JOIN FETCH c.user " +           // user를 함께 가져옴
            "JOIN FETCH c.post " +           // post도 함께 가져옴
            "WHERE c.post.id = :postId " +
            "ORDER BY c.createdAt DESC")
    List<PostComment> findByPostIdWithUserAndPost(Long postId);
}
