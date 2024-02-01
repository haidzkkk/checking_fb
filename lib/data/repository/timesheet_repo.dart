
import 'package:timesheet/data/api/api_client.dart';

import '../../utils/app_constants.dart';
import 'package:get/get.dart';

class TimeSheetRepo{
  final ApiClient apiClient;

  TimeSheetRepo({required this.apiClient});

  Future<Response> getTimeSheets() async => await apiClient.getData(AppConstants.GET_TIME_SHEET);
  Future<Response> checkInTimeSheet(String ip) async => await apiClient.getData(AppConstants.GET_TIME_SHEET_CHECKIN, query: {"ip": ip});
}