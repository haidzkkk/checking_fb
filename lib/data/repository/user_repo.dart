
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:http/http.dart' as Http;
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import '../model/body/pageable.dart';
import '../model/body/user.dart';
import 'package:get/get.dart';


class UserRepo{
  final ApiClient apiClient;
  UserRepo({required this.apiClient});


  Future<Response> getListUser(Pageable pageable) async{
    return await apiClient.postData(AppConstants.GET_USERS,
        jsonEncode(pageable),
       null
    );
  }

  Future<Response> getCurrentUser() async{
    return await apiClient.getData(AppConstants.GET_USER);
  }

  Future<Response> getUserById(int userId) async{
    return await apiClient.getData("${AppConstants.GET_USER_BY_ID}$userId");
  }

  Future<Response> updateUserMySelf(User user) async{
    return await apiClient.postData(
        AppConstants.UPDATE_USER_MYSELF,
        jsonEncode(user),
        null
    );
  }

  Future<Response> updateUserById(User user) async{
    return await apiClient.postData(
        "${AppConstants.UPDATE_USER_BY_ID}${user.id}",
        jsonEncode(user),
        null
    );
  }

  Future<Response> blockUser(String userId) async{
    return await apiClient.getData("${AppConstants.UPDATE_BLOCK_USER_BY_ID}$userId");
  }
}