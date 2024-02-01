import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/time_sheet.dart';
import 'package:timesheet/helper/date_converter.dart';
import '../data/api/api_checker.dart';
import '../data/repository/timesheet_repo.dart';

class TimeSheetController extends GetxController implements GetxService {
  final TimeSheetRepo repo;
  TimeSheetController({required this.repo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TimeSheet> _timeSheets = <TimeSheet>[];
  List<TimeSheet> get timeSheets => _timeSheets;

  RxDouble totalDayInMonth = 0.0.obs;
  RxDouble totalDayCheckinInMonth = 0.0.obs;
  RxDouble progressRate = 0.0.obs;

  /*
  *
  * */
  void handleProgressInMonth(DateTime dateTime){
    double myTotalDayInMonth = DateTime(dateTime.year , dateTime.month + 1, 0).day.toDouble();
    double myTotalDayCheckinInMonth = 0;

    for (var element in timeSheets) {
      DateTime? dateCheckin = element.dateAttendance?.convertToDate(DateConverter.dateIso8601Format2);
      if(dateCheckin != null && dateTime.year == dateCheckin.year && dateTime.month == dateCheckin.month){
        myTotalDayCheckinInMonth += 1;
      }
    }
    progressRate.value = ((100 / myTotalDayInMonth) * myTotalDayCheckinInMonth) / 100;
    totalDayInMonth.value = myTotalDayInMonth;
    totalDayCheckinInMonth.value = myTotalDayCheckinInMonth;
  }

  Map<DateTime, List<TimeSheet>> getEventsCalendar(){
    Map<DateTime, List<TimeSheet>> _event = {};
    for (var element in _timeSheets) {
      DateTime? dateTime = element.dateAttendance?.convertToDate(DateConverter.dateIso8601Format2);
      if(dateTime != null){
        DateTime key = DateTime(dateTime.year, dateTime.month, dateTime.day).toLocal();
        _event[key] = [element];
      }
    }
    return _event;
  }

  /*
  *
  * */

  Future<int> getTimeSheet() async {
    _isLoading = true;
    update();
    Response response = await repo.getTimeSheets();

    if (response.statusCode == 200) {
      print(response.body);
      List<TimeSheet> convertListTimeSheets = (response.body as List<dynamic>).map((json) => TimeSheet.fromJson(json)).toList();
      _timeSheets = convertListTimeSheets;
      handleProgressInMonth(DateTime.now());
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

  Future<int> checkIn() async {
    _isLoading = true;
    update();
    Response response = await repo.checkInTimeSheet("100.31.12.411");

    if (response.statusCode == 200) {
      TimeSheet? timeSheet = TimeSheet.fromJson(response.body);

      timeSheets.add(timeSheet);
      handleProgressInMonth(DateTime.now());
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }

}