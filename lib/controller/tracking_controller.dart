import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/tracking.dart';
import 'package:timesheet/data/repository/tracking_repo.dart';
import 'package:timesheet/helper/date_converter.dart';

import '../data/api/api_checker.dart';

class TrackingController extends GetxController implements GetxService{
  ScrollController? scrollController;

  final TrackingRepo repo;
  TrackingController({required this.repo});

  bool _loading = false;
  var _listTracking = <Tracking>[];

  bool get loading => _loading;
  List<Tracking> get listTracking => _listTracking;

  void onDispose(){
    scrollController?.dispose();
  }

  Future<int> getTracking() async {
    _loading = true;
    update();
    Response response = await repo.getAllTracking();

    debugPrint("okeoke: ${response.statusCode}");
    if (response.statusCode == 200) {
      List<Tracking> convertListTracking = (response.body as List<dynamic>).map((json) => Tracking.fromJson(json)).toList();
      _listTracking = convertListTracking;
    }
    else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> addTracking(String content) async{
      _loading = true;
      update();
      Tracking tracking = Tracking(
          id: null,
          content: content,
          date: DateTime.now().formatToString(DateConverter.dateIso8601Format),
          user: null
      );

      Response response = await repo.addTracking(tracking);
      debugPrint("okeoke: ${response.statusCode}");
      if (response.statusCode == 200) {
        Tracking tracking = Tracking.fromJson(response.body);
        _listTracking.add(tracking);
      }
      else {
        ApiChecker.checkApi(response);
      }
      _loading = false;
      update();
      return response.statusCode!;
  }
  Future<int> updateTracking(Tracking tracking, String content) async{
      _loading = true;
      update();

      tracking.content = content;

      Response response = await repo.updateTracking(tracking.id, tracking);
      debugPrint("okeoke: ${response.statusCode}");
      if (response.statusCode == 200) {
        Tracking trackingUpdate = Tracking.fromJson(response.body);

       _listTracking.forEach((element) {
         if(element.id == trackingUpdate.id){
           element = trackingUpdate;
           return;
         }
       });
      }
      else {
        ApiChecker.checkApi(response);
      }
      _loading = false;
      update();
      return response.statusCode!;
  }
  Future<int> deleteTracking(Tracking tracking) async{
      _loading = true;
      update();
      debugPrint("delete:");
      Response response = await repo.deleteTracking(tracking.id);
      if (response.statusCode == 200) {
        Tracking? trackingDelete = Tracking.fromJson(response.body);
         int index = _listTracking.indexOf(trackingDelete);
         if(index != -1){
           _listTracking.removeAt(index);
         }
      }
      else {
        ApiChecker.checkApi(response);
      }
      _loading = false;
      update();
      return response.statusCode!;
  }
}