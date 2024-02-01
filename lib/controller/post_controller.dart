
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/pageable.dart';
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/post/content_response.dart';
import 'package:timesheet/data/model/body/post/like.dart';
import 'package:timesheet/data/model/body/post/media.dart';
import 'package:timesheet/data/model/body/post/content_request.dart';
import 'package:timesheet/data/repository/post_repo.dart';
import 'package:timesheet/helper/date_converter.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/post/content.dart';
import '../data/model/body/post/paginated_data.dart';

class PostController extends GetxController implements GetxService {
  final PostRepository repo;
  PageController? pageController;
  PostController({required this.repo});

  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int currentPageByUser = 1;
  bool isLastPageByUser = false;

  List<Content> _posts = [];
  List<Content> _postsByUser = [];
  List<Content> get posts => _posts;
  List<Content> get postsByUser => _postsByUser;

  onDisPose(){
    pageController?.dispose();
  }

  Future<void> resetListPost(){
    _isLastPage = false;
    _currentPage = 1;
    return getPost();
  }

  Future<void> resetListPostByUser(){
    isLastPageByUser = false;
    currentPageByUser = 1;
    return getPostByUser();
  }

  void clearListPostByUser()async {
    isLastPageByUser = false;
    currentPageByUser = 1;
    _postsByUser.clear();
  }

  Future<int> getPost() async {
    if(_isLastPage) return 404;
    _isLoading = true;
    update();
    Response response = await repo.getPost(Pageable(_currentPage, 10));

    if (response.statusCode == 200) {
      PaginatedData paginatedData = PaginatedData.fromJson(response.body);
      if(paginatedData.content.isNotEmpty){
        if(_currentPage == 1) _posts.clear();
        _currentPage += 1;
        _posts.addAll(paginatedData.content);
      }else{
        _isLastPage = true;
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> getPostByUser() async {
    if(isLastPageByUser) return 404;

    _isLoading = true;
    update();
    Response response = await repo.getPostByUser(Pageable(currentPageByUser, 10));

    if (response.statusCode == 200) {
      PaginatedData paginatedData = PaginatedData.fromJson(response.body);
      if(paginatedData.content.isNotEmpty){
        if(currentPageByUser == 1) _postsByUser.clear();
        currentPageByUser += 1;
        _postsByUser.addAll(paginatedData.content);
      }else{
        isLastPageByUser = true;
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> createPost(ContentRequest contentRequest) async {
    _isLoading = true;
    update();

    Response response = await repo.createPost(contentRequest);
    print("${response.statusCode}");

    if (response.statusCode == 200) {
      ContentResponse contentRes = ContentResponse.fromJson(response.body);
      _posts.insert(0, contentRes.data);
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> likePost(String postId, bool isPostByUser) async {
    _isLoading = true;
    update();

    Like like = Like(id: 0, date: DateTime.now().formatToISOString(), type: 0);

    Response response = await repo.likePost(postId, like);
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      Like likeResponse = Like.fromJson(response.body);

      Content? postFind;
      if(isPostByUser){
        postFind = _postsByUser.firstWhereOrNull((element) => element.id.toString() == postId);
      }else{
        postFind =  _posts.firstWhereOrNull((element) => element.id.toString() == postId);
      }
      postFind?.likes.add(likeResponse);
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> commentPost(String postId, String content, bool isPostByUser) async {
    _isLoading = true;
    update();

    Comment comment = Comment(id: 0, content: content, date: DateTime.now().microsecond);

    Response response = await repo.commentPost(postId, comment);
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      Comment commentResponse = Comment.fromJson(response.body);

      Content? postFind;
      if(isPostByUser){
        postFind =  _postsByUser.firstWhereOrNull((element) => element.id.toString() == postId);
      }else{
        postFind =  _posts.firstWhereOrNull((element) => element.id.toString() == postId);
      }
      postFind?.comments.add(commentResponse);
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }
}