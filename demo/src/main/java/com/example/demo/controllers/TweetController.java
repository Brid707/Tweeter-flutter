package com.example.demo.controllers;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.models.Tweet;
import com.example.demo.repository.TweetRepository;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/tweets")
public class TweetController {

    @Autowired
    private TweetRepository tweetRepository;

    @GetMapping("")
    public Page<Tweet> getTweet(Pageable pageable) {
        return tweetRepository.findAll(pageable);
    }

    @PostMapping("")
    public Tweet createTweet(@Valid @RequestBody Tweet tweet) {
        Tweet myTweet = new Tweet(tweet.getTweet());
        tweetRepository.save(myTweet);
        return myTweet;
    }

    @DeleteMapping("/{id}")
    public void deleteTweet(@PathVariable Long id) {
        tweetRepository.deleteById(id);
    }
}
