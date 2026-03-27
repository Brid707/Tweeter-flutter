import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tweet.dart';
import '../models/tweet_response.dart';

class TweetService {
  static final TweetService _instance = TweetService._internal();

  final String baseUrl = 'https://tweeter-api-28or.onrender.com/api';
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

  Future<List<Tweet>> fetchTweets() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/tweets'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final tweetResponse = TweetResponse.fromJson(jsonData);
        return tweetResponse.content;
      } else {
        throw Exception(
          'Failed to load tweets. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching tweets: $e');
    }
  }

  Future<bool> deleteTweet(int id) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/tweets/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          'Failed to delete tweet. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting tweet: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
