
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

import '../helper/date_converter.dart';

class Custom{

  static Future<DateTime?> showDialogCalendar({required BuildContext context, required DateTime? timeBirthday, required TextEditingController dateBirthDayTextController}) async{
    DateTime? curentDate;
    await showDialog(context: context, builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          height: 230,
          child:  Column(
            children: [
              DatePickerWidget(
                looping: false, // default is not looping
                firstDate: DateTime(1900, 01, 01),
                lastDate: DateTime.now(),
                initialDate: timeBirthday ?? DateTime.now(),
                dateFormat: "dd-MMM-yyyy",
                locale: DatePicker.localeFromString('en'),
                onChange: (DateTime newDate, _) {
                  curentDate = newDate;
                },
                pickerTheme: const DateTimePickerTheme(
                  itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                  dividerColor: Colors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text("cancel".tr),),
                  TextButton(onPressed: () {
                    dateBirthDayTextController.text = curentDate?.formatToString(DateConverter.dateFormat) ?? "null";
                    Navigator.pop(context);
                  }, child: Text("done".tr),),
                ],
              )
            ],
          ),
        ),
      );
    });
    return curentDate;
  }

  static Widget widgetAvatar({
    String? url,
    required double height,
    required double width,
    required double widthScreen,
    Function(String?)? onpress}
      ) {
    return InkWell(
      onTap: (){
        if(onpress != null) onpress(url);
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipOval(
          child: onpress == null
              ? FullScreenWidget(
                  disposeLevel: DisposeLevel.High,
                  child: Center(
                    child: Hero(
                      tag: "avatar",
                      child: Image.network(
                          width: widthScreen,
                          height: widthScreen,
                          url ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, object, stratre) =>
                              Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: width,
                              )
                      ),
                    ),
                  ),
                )
              : Image.network(
              '$url?random=${DateTime.now().millisecondsSinceEpoch}',
              fit: BoxFit.cover,
              errorBuilder: (context, object, stratre) =>
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: width,
                  )
          ),
        ),
      ),
    );
  }

  static Widget widgetPhotoCover({
    String? url,
    required double height,
    required double width,
    Function(String?)? onpress}
      ) {
    return InkWell(
      onTap: (){
        if(onpress != null) onpress(url);
      },
      child: FullScreenWidget(
        disposeLevel: DisposeLevel.High,
        child: Center(
          child: Hero(
            tag: "cover_photo",
            child: Container(
              width: width,
              color: Colors.white,
              child: Image.network(
                  '$url?random=${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, object, stratre) =>
                      Container(
                          width: width,
                          height: height,
                          color: Colors.grey
                      )
              ),

              // CachedNetworkImage(
              //     fit: BoxFit.cover
              //     ,
              //     imageUrl: url ?? "",
              //     errorWidget: (context, url, error) =>
              //         Container(
              //             width: width,
              //             height: height,
              //             color: Colors.grey
              //         )
              // ),
            ),
          ),
        ),
      ),
    );
  }
}