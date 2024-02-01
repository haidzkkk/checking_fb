
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/body/tracking.dart';
import '../../helper/date_converter.dart';
import '../../view/custom_snackbar.dart';

class ItemTracking extends StatelessWidget{
  Tracking tracking;
  final Function(Tracking? tracking)? onPressed;
  final Function(Tracking? tracking)? onDelete;

  ItemTracking({super.key, required this.tracking, this.onPressed, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onPressed != null) onPressed!(tracking);
    },
      child: Container(
        color: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tracking.date?.formatStringDateToString(DateConverter.dateIso8601Format2 , DateConverter.dateTimeHourFormat) ?? 'null',
                            style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                          Text(tracking.date?.formatStringDateToString(DateConverter.dateIso8601Format2 , DateConverter.dateFormat) ?? 'null',
                            style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                        ],
                      )
                  ),
                  SizedBox(
                    height: 100,
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tracking.content ?? "null", style: const TextStyle(color: Colors.black, fontSize: 15),),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                child: PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: 0,
                      child: const Text('Xóa'),
                      onTap: (){
                        showCustomSnackBar("Bạn có muốn xóa tracking này?",
                            isError: false,
                            lable: "Xóa",
                            onPressed: (){
                              if(onDelete != null) onDelete!(tracking);
                            });
                      },
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

}