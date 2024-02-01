
import 'dart:convert';

import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/post/content_request.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

import '../model/body/pageable.dart';
import '../model/body/post/like.dart';

class PostRepository{
  final ApiClient apiClient;

  PostRepository({required this.apiClient});

  Future<Response> getPost(Pageable pageable) async {
    return await apiClient.postData(
        AppConstants.GET_POST,
        jsonEncode(pageable),
        null
    );
  }


  Future<Response> getPostByUser(Pageable pageable) async {
    return await apiClient.postData(
        AppConstants.GET_POST_BY_USER,
        jsonEncode(pageable),
        null
    );
  }


  Future<Response> createPost(ContentRequest contentRequest) async {
    print(contentRequest);
    return await apiClient.postData(
      AppConstants.CREATE_POST,
      jsonEncode(contentRequest),
      null
    );
  }

  Future<Response> likePost(String postId, Like like) async {
    return await apiClient.postData(
      AppConstants.LIKE_POST + postId,
      jsonEncode(like),
      null
    );
  }

  Future<Response> commentPost(String postId, Comment comment) async {
    return await apiClient.postData(
      AppConstants.COMMENT_POST + postId,
      jsonEncode(comment),
      null
    );
  }
}