import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:machine_test_lahara/features/posts/data/models/post_model.dart';


class ApiException implements Exception {
  final String message;
  final bool isNetworkError;
  ApiException(this.message, {this.isNetworkError = false});

  @override
  String toString() => message;
}

class ApiService {
  final baseUrl = "https://jsonplaceholder.typicode.com";

  
  
  Future<List<PostModel>> getPosts({
    required int start,
    required int limit,
  }) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/posts?_start=$start&_limit=$limit"))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => PostModel.fromJson(e)).toList();
      }
      throw ApiException(
          "Server error (${response.statusCode}). Please try again.");
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException("No internet connection. Please check your network.",
          isNetworkError: true);
    } on http.ClientException {
      throw ApiException("No internet connection. Please check your network.",
          isNetworkError: true);
    } on TimeoutException {
      throw ApiException("The request timed out. Please try again.",
          isNetworkError: true);
    } catch (_) {
      throw ApiException("Something went wrong. Please try again.");
    }
  }

  Future<PostModel> getPostById(int id) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/posts/$id"))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return PostModel.fromJson(json.decode(response.body));
      }
      throw ApiException(
          "Server error (${response.statusCode}). Please try again.");
    } on ApiException {
      rethrow;
    } on SocketException {
      throw ApiException("No internet connection. Please check your network.",
          isNetworkError: true);
    } on http.ClientException {
      throw ApiException("No internet connection. Please check your network.",
          isNetworkError: true);
    } on TimeoutException {
      throw ApiException("The request timed out. Please try again.",
          isNetworkError: true);
    } catch (_) {
      throw ApiException("Something went wrong. Please try again.");
    }
  }
}