
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/notfication.dart';
import 'package:timesheet/data/repository/notify_repo.dart';

import '../data/api/api_checker.dart';

class NotifyController extends GetxController implements GetxService {
  ScrollController? scrollController;
  NotifyController({required this.repo});
  final NotifyRepo repo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Notify> _notifies = <Notify>[];
  List<Notify> get notifies => _notifies;

  Future<int> getNotify() async {
    _isLoading = true;
    update();
    Response response = await repo.getNotify();

    if (response.statusCode == 200) {
      print(response.body);
      _notifies = (response.body as List<dynamic>).map((json) => Notify.fromJson(json)).toList();
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  onDispose(){
    scrollController?.dispose();
  }
}