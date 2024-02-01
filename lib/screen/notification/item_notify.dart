
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/data/model/body/notfication.dart';
import 'package:timesheet/helper/date_converter.dart';

class ItemNotify extends StatelessWidget{
  Notify notify;
  final Function(Notify? notify)? onPressed;

  ItemNotify({super.key, required this.notify, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onPressed != null) onPressed!(notify);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        margin: const EdgeInsets.only(bottom: 5),
        height: 100,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              width: 60,
              height: 60,
              child: RawMaterialButton(
                  onPressed: (){
                  },
                  fillColor: Colors.white.withOpacity(0.9),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.person, size: 50, color: Colors.grey,)
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(fontSize: 18),
                        children:  <TextSpan>[
                          TextSpan(text: 'user'.tr, style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: " ${"notified".tr} ${notify.title} ${"is".tr} ${notify.body}",
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                        ]
                    ),
                  ),
                  Text(
                    "${notify.date?.formatStringDateISOToString(DateConverter.dateDay2Format)} ${"at".tr} ${notify.date?.formatStringDateISOToString(DateConverter.dateTimeHourFormat)}",
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}