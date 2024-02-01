import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateConverter on DateTime{

  static DateFormat dateIso8601Format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat dateIso8601Format2 = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
  static DateFormat dateTimeFormat = DateFormat("HH:mm:ss");
  static DateFormat dateTimeHourFormat = DateFormat("HH:mm");
  static DateFormat dateDayFormat = DateFormat("EEE dd/MM/yy");
  static DateFormat dateDay2Format = DateFormat("EEE dd/MM");
  static DateFormat dateDay3Format = DateFormat("HH:mm - dd/MM");
  static DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  static DateFormat dateMonthFormat = DateFormat("MMM yyyy");
  static DateFormat dateDayTimeFormat = DateFormat("EEE dd/MM/yy\nHH:mm:ss");

  String formatToString(DateFormat dfConvert) => dfConvert.format(this);
  String formatToISOString() => dateIso8601Format.format(this);

  String formatToStringTime(){
    String result = "";
    DateTime now =  DateTime.now();
    DateTime daySelect = this;

    Duration difference = now.difference(daySelect);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if(days > 0) {
      result = "$days ngày trước";
    } else if(hours > 0){
      result = "$hours giờ trước";
    } else{
      result = "$minutes phút trước";
    }
    return result;
  }
}

extension StringDateConverter on String {

  String formatStringDateToString(DateFormat dfConvert, DateFormat dfResult) {
    return dfResult.format(dfConvert.parse(this));
  }

  String formatStringDateISOToString(DateFormat dfResult) {
    return dfResult.format(DateConverter.dateIso8601Format2.parse(this));
  }

  DateTime convertToDate(DateFormat dfConvert) => dfConvert.parse(this);

  DateTime convertISOToDate() => DateConverter.dateIso8601Format2.parse(this);

}


