import 'package:get/get.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'dart:async';
import '../api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CCDCRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  CCDCRepo({required this.apiClient,required this.sharedPreferences});

  Future<Response> getAllocationVouchers(int? index) async{
    if(index != null){
      Map<String, dynamic> query = {
        'keyword':'',
        'statusIndex':index.toString()
      };
      return await apiClient.getData(AppConstants.GET_ALLOCATION_VOUCHERS,query: query);
    }
    return await apiClient.getData(AppConstants.GET_ALLOCATION_VOUCHERS);
  }
}