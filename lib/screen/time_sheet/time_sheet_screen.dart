import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/data/model/body/time_sheet.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/helper/notification_helper.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimeSheetScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TimeSheetScreenState();
}

class TimeSheetScreenState extends State<TimeSheetScreen> {

  Future<void> _onRefesh() {
    return Get.find<TimeSheetController>().getTimeSheet();
  }

  @override
  void initState() {
    super.initState();
    Get.find<TimeSheetController>().getTimeSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: RefreshIndicator(
            onRefresh: _onRefesh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<TimeSheetController>(builder: (controller) {
                      Map<DateTime, List<TimeSheet>> _events = controller.getEventsCalendar();
                      return TableCalendar(
                        firstDay: DateTime(1990, 01, 01),
                        lastDay: DateTime(2030, 1, 1),
                        focusedDay: DateTime.now(),
                        eventLoader: (day) {
                          DateTime dayCompare = DateTime(day.year, day.month, day.day).toLocal();
                          return _events[dayCompare] ?? [];
                        },
                        onDaySelected: (day1, day2){
                          DateTime dayCompare = DateTime(day1.year, day1.month, day1.day).toLocal();
                          TimeSheet? timeSheet = _events[dayCompare]?.first;
                          if(timeSheet != null){
                            showTimeSheetBottomSheet(context, timeSheet);
                          }
                        },
                        onPageChanged: (focusedDay){
                          controller.handleProgressInMonth(focusedDay);
                        },
                      );
                    }),

                    Obx(() => Text("${"total_day".tr}: ${Get.find<TimeSheetController>().totalDayCheckinInMonth.value.toInt()}/${Get.find<TimeSheetController>().totalDayInMonth.value.toInt()}")),
                    Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        child: LinearProgressIndicator(
                          value:  Get.find<TimeSheetController>().progressRate.value,
                        )
                    ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomButton(
            margin: const EdgeInsets.all(10),
            buttonText: "attendance".tr,
            onPressed: (){
              handleCheckin();
            },
          ),
        ),
        Center(
          child: GetBuilder<TimeSheetController>(builder: (controller) {
            return Visibility(
                visible: controller.isLoading,
                child: const CircularProgressIndicator()
            );
          }),
        )
      ],
    );
  }

  Future showTimeSheetBottomSheet(BuildContext context, TimeSheet timeSheet) {
    DateTime? daySelect = timeSheet.dateAttendance?.convertToDate(DateConverter.dateIso8601Format2);
    return showModalBottomSheet(context: context,

        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${daySelect?.formatToString(DateConverter.dateDayTimeFormat)}",
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                    ),
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(timeSheet.message ?? "no_message".tr)
              ],
            ),
          );
      }
    );
  }

  void handleCheckin() {
    Get.find<TimeSheetController>().checkIn()
        .then((value) {
      if (value == 200 || value == 201){
        showCustomSnackBar("success".tr, isError: false);
      }else{
        showCustomSnackBar("faild".tr);
      }
    });

  }

}