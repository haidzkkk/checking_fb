
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:timesheet/data/model/body/page.dart';
import 'package:timesheet/data/repository/user_repo.dart';
import 'package:timesheet/utils/app_constants.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/pageable.dart';
import '../data/model/body/user.dart';

class UserController extends GetxController implements GetxService{
  final UserRepo repo;
  UserController({required this.repo});

  ScrollController? scrollController;

  int currentPage = 1;
  bool isLastPage = false;
  bool _loading = false;
  bool isMyProfile = false;
  bool isAdmin = false;

  List<User> _users = <User>[];
  User _currentUser = User();
  User? _currentUserProfile;

  bool get loading => _loading;
  User get currentUser => _currentUser;
  User? get currentUserProfile => _currentUserProfile;
  List<User> get users => _users;

  void resetDataProfile(){
    isAdmin = false;
    isMyProfile = false;
    _currentUserProfile = null;
  }

  Future<void> restartListUser(){
    isLastPage = false;
    currentPage = 1;
    return getListUsers();
  }

  Future<int> getListUsers() async{
    _loading = true;
    update();

    if(isLastPage){
      return Future.error(Error());
    }

    Response response = await repo.getListUser(Pageable(currentPage, 10));
    if(response.statusCode == 200){
      PageResponse<User>? page = PageResponse.fromJson(response.body, (e) => User.fromJson(e));
      if(page.content != null && page.content!.isNotEmpty){
        if(currentPage == 1) users.clear();

          users.addAll(page.content!);
          currentPage += 1;
      }else{
        isLastPage = true;
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }


  Future<int> getCurrentUser() async {
    Response response = await repo.getCurrentUser();
    if(response.statusCode == 200){
      _currentUser = User.fromJson(response.body);
      isAdmin = _currentUser.roles?[0].authority == "ROLE_ADMIN";
    }
    else {
      ApiChecker.checkApi(response);
    }

    isMyProfile = currentUserProfile?.id == currentUser.id;
    update();
    return response.statusCode!;
  }


  Future<int> getCurrentUserProfile(int? userId) async {
    _loading = true;
    update();

    Response response;
    if(userId != null){
      response = await repo.getUserById(userId);
    }else{
      response = await repo.getCurrentUser();
      isMyProfile = true;
    }

    if(response.statusCode == 200){
      _currentUserProfile = User.fromJson(response.body);
    }
    else {
      isAdmin = false;
      isMyProfile = false;
      _currentUserProfile = null;
      ApiChecker.checkApi(response);
    }


    isMyProfile = currentUserProfile?.id == currentUser.id;
    _loading = false;
    update();
    return response.statusCode!;
  }


  Future<int> updateUser() async {
    _loading = true;
    update();

    if(currentUserProfile == null){
      return Future.error(Error());
    }

    Response response;
    if(isMyProfile){
      response = await repo.updateUserMySelf(currentUserProfile!);
    }else if(isAdmin){
      response = await repo.updateUserById(currentUserProfile!);
    }else{
      return Future.error(Error());
    }

    if(response.statusCode == 200){
      _currentUserProfile = User.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }


  Future<int> blockUser() async {
    _loading = true;
    update();

    if(currentUserProfile == null){
      return Future.error(Error());
    }

    Response response;
    if(currentUserProfile?.id != null && !isMyProfile && isAdmin){
      if(currentUserProfile!.active == true){
        response = await repo.blockUser(currentUserProfile!.id.toString());
      }else{
        currentUserProfile!.active = true;
        response = await repo.updateUserById(currentUserProfile!);
      }
    }else{
      return Future.error(Error());
    }

    if(response.statusCode == 200){
      _currentUserProfile = User.fromJson(response.body);
    }
    else {
      ApiChecker.checkApi(response);
    }

    _loading = false;
    update();
    return response.statusCode!;
  }

  onDispose(){
    scrollController?.dispose();
  }
}