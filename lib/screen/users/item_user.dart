
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_button.dart';

import '../../view/custom.dart';


class ItemUser extends StatelessWidget{
  ItemUser({super.key, required this.user, this.onPressed});
  User user;
  final Function(User? user)? onPressed;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Custom.widgetAvatar(
                  url: user.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                  height: 100,
                  width: 100,
                  widthScreen: MediaQuery.of(context).size.width,
                  onpress: (value){
                    if(onPressed != null) onPressed!(user);
                  }
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${user.displayName}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                Text("${user.university}", style: const TextStyle(fontSize: 16, color: Colors.grey),),
                CustomButton(
                  width: 200,
                  height: 40,
                  buttonText: "view_personal_page".tr,
                  onPressed: (){
                    if(onPressed != null) onPressed!(user);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}