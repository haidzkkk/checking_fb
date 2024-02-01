
import '../api/api_client.dart';
import '../../utils/app_constants.dart';
import 'package:get/get.dart';

class NotifyRepo{
  final ApiClient apiClient;

  NotifyRepo({required this.apiClient});

  Future<Response> getNotify() async => await apiClient.getData(AppConstants.GET_NOTIFY);
}