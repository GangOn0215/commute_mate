package com.example.hello.service;

import com.example.hello.dto.LikeResponse;
import com.example.hello.dto.comment.PostCommentRequest;
import com.example.hello.entity.CommentLike;
import com.example.hello.entity.Post;
import com.example.hello.entity.PostComment;
import com.example.hello.entity.User;
import com.example.hello.repository.CommentLikeRepository;
import com.example.hello.repository.PostCommentRepository;
import com.example.hello.repository.PostsRepository;
import com.example.hello.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PostCommentService {

    public final PostCommentRepository postCommentRepository;
    private final UserRepository userRepository;
    private final PostsRepository postsRepository;
    private final CommentLikeRepository commentLikeRepository;

    @Autowired
    public PostCommentService(PostCommentRepository postCommentRepository, UserRepository userRepository, PostsRepository postsRepository, CommentLikeRepository commentLikeRepository) {
        this.postCommentRepository = postCommentRepository;
        this.userRepository = userRepository;
        this.postsRepository = postsRepository;
        this.commentLikeRepository = commentLikeRepository;
    }

    public List<PostComment> getAllPostComments() {
        return postCommentRepository.findAll();
    }

    public List<PostComment> getByPostId(Long postId) {
        return postCommentRepository.findByPostIdWithUserAndPost(postId);
    }

    public PostComment create(PostCommentRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Post post = postsRepository.findById(request.getPostId())
                .orElseThrow(() -> new IllegalArgumentException("Post not found"));

        PostComment.PostCommentBuilder builder = PostComment.builder()
                .user(user)
                .post(post)
                .content(request.getContent());

        if (request.getParentId() != null) {
            PostComment parent = postCommentRepository.findById(request.getParentId())
                    .orElseThrow(() -> new IllegalArgumentException("Parent comment not found"));

            // 2단계 제한: 대댓글에 대댓글 금지
            if (parent.getParent() != null) {
                throw new IllegalArgumentException("대댓글에는 답글을 달 수 없습니다.");
            }

            // 부모 댓글이 같은 게시글인지 검증
            if (!parent.getPost().getId().equals(request.getPostId())) {
                throw new IllegalArgumentException("댓글과 게시글이 일치하지 않습니다.");
            }

            builder.parent(parent);
        }

        return postCommentRepository.save(builder.build());
    }

    public void delete(Long commentId) {
        PostComment comment = postCommentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("Comment not found"));
        comment.setDeletedAt(LocalDateTime.now());
        postCommentRepository.save(comment);
    }

    // 댓글 좋아요 토글
    public LikeResponse toggleLike(Long commentId, Long userId) {
        PostComment comment = postCommentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("Comment not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        boolean alreadyLiked = commentLikeRepository.existsByCommentIdAndUserId(commentId, userId);

        if (alreadyLiked) {
            commentLikeRepository.findByCommentIdAndUserId(commentId, userId)
                    .ifPresent(commentLikeRepository::delete);
            comment.setLikeCount(Math.max(0, (comment.getLikeCount() != null ? comment.getLikeCount() : 0) - 1));
        } else {
            commentLikeRepository.save(CommentLike.builder().comment(comment).user(user).build());
            comment.setLikeCount((comment.getLikeCount() != null ? comment.getLikeCount() : 0) + 1);
        }

        postCommentRepository.save(comment);
        return new LikeResponse(comment.getLikeCount(), !alreadyLiked);
    }
}
