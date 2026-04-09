import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tweet.dart';
import '../models/tweet_response.dart';
import '../repositories/tweet_repository.dart';

class TweetService implements ITweetRepository {
  static final TweetService _instance = TweetService._internal();

  final String baseUrl = 'https://tweeter-api-28or.onrender.com';
  late http.Client _httpClient;

  TweetService._internal() {
    _httpClient = http.Client();
  }

  factory TweetService() {
    return _instance;
  }

  static TweetService getInstance() {
    return _instance;
  }

  @override
  Future<List<Tweet>> fetchTweets() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/tweets'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return _parseGetTweetsResponse(response.body);
      } else {
        throw Exception(
          'Failed to load tweets. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching tweets: $e');
    }
  }

  @override
  Future<Tweet> createTweet(String content) async {
    try {
      if (content.trim().isEmpty) {
        throw Exception('Tweet content cannot be empty');
      }

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/tweets'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tweet': content,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _parseTweetResponse(response.body);
      } else {
        throw Exception(
          'Failed to create tweet. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating tweet: $e');
    }
  }

  @override
  Future<void> deleteTweet(int id) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/tweets/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete tweet. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting tweet: $e');
    }
  }

  List<Tweet> _parseGetTweetsResponse(String responseBody) {
    final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
    final tweetResponse = TweetResponse.fromJson(jsonData);
    return tweetResponse.content;
  }

  Tweet _parseTweetResponse(String responseBody) {
    final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
    return Tweet.fromJson(jsonData);
  }

  @override
  void dispose() {
    _httpClient.close();
  }
}
