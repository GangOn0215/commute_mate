package com.example.hello.repository;

import com.example.hello.entity.PostComment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface PostCommentRepository extends JpaRepository<PostComment, Long> {

    // 최상위 댓글만 조회 (parent IS NULL), user/replies/replies.user 한 번에 fetch
    @Query("SELECT DISTINCT c FROM PostComment c " +
            "JOIN FETCH c.user " +
            "LEFT JOIN FETCH c.replies r " +
            "LEFT JOIN FETCH r.user " +
            "WHERE c.post.id = :postId AND c.parent IS NULL " +
            "ORDER BY c.createdAt DESC")
    List<PostComment> findByPostIdWithUserAndPost(@Param("postId") Long postId);

    Integer countByPostIdAndDeletedAtIsNull(Long id);
}
