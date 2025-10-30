package com.example.hello.service;

import com.example.hello.entity.Posts;
import com.example.hello.repository.PostsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Service
public class PostsService {
    public final PostsRepository postRepository;
    private final PostsRepository postsRepository;

    @Autowired
    public PostsService(PostsRepository postRepository, PostsRepository postsRepository) {
        this.postRepository = postRepository;
        this.postsRepository = postsRepository;
    }

    public List<Posts> getAll() {
        return postRepository.findAll();
    }

    public List<Posts> getAllPosts() {
        return postsRepository.findAllWithUser();
    }

    public Posts create(Posts posts) {
        return postRepository.save(posts);
    }

    public Posts update(Posts posts) {
        return postRepository.save(posts);
    }

    public Posts findById(Long id) {
        return postRepository.findById(id).get();
    }
}
