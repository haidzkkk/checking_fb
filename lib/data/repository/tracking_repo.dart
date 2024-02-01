import 'dart:convert';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class TrackingRepo {
  final ApiClient apiClient;

  TrackingRepo({required this.apiClient});


  Future<Response> getAllTracking() async => await apiClient.getData(AppConstants.GET_TRACKING);
  Future<Response> addTracking(tracking) async => await apiClient.postData(AppConstants.GET_TRACKING, jsonEncode(tracking), null);
  Future<Response> updateTracking(id, tracking) async => await apiClient.postData("${AppConstants.GET_TRACKING}/$id", jsonEncode(tracking), null);
  Future<Response> deleteTracking(id) async => await apiClient.deleteData("${AppConstants.GET_TRACKING}/$id", headers: null);

}