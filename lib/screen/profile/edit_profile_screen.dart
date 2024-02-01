
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/user_controller.dart';

import '../../data/model/body/user.dart';
import '../../helper/date_converter.dart';
import '../../view/custom.dart';
import '../../view/custom_snackbar.dart';
import '../../view/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _universityTextController = TextEditingController();
  final TextEditingController _leverTextController = TextEditingController();
  final TextEditingController _dateBirthDayTextController = TextEditingController();
  final TextEditingController _birthPlaceTextController = TextEditingController();

  DateTime? _timeBirthday;
  String _valueGender = "m";

  @override
  void initState() {
    User? currentUserProfile = Get.find<UserController>().currentUserProfile;

    _emailTextController.text = currentUserProfile?.email ?? "";
    _universityTextController.text = currentUserProfile?.university ?? "";
    _leverTextController.text = currentUserProfile?.year.toString() ?? "";
    _birthPlaceTextController.text = currentUserProfile?.birthPlace ?? "";

    _timeBirthday = currentUserProfile?.dob?.convertISOToDate();
    _valueGender = currentUserProfile?.gender ?? "m";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text("edit".tr, style: const TextStyle(color: Colors.black),),
        actions: [
          InkWell(
            onTap: (){
              updateUser();
            },
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Text("done".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),)
                )
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("personal_info".tr, style: TextStyle(fontWeight: FontWeight.bold),),
            CustomTextField(
              controller: _emailTextController,
              padding: const EdgeInsets.only(top: 20),
              lable: "email",
              inputType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: _universityTextController,
              padding: const EdgeInsets.only(top: 10),
              lable: "university".tr,
            ),
            CustomTextField(
              controller: _leverTextController,
              padding: const EdgeInsets.only(top: 10),
              lable: "lever".tr,
              inputType: TextInputType.phone,
            ),
            SizedBox(
              height: 75,
              child: DropdownButtonFormField(
                value: _valueGender,
                isDense: true,
                padding: const EdgeInsets.only(top: 10),
                items: <DropdownMenuItem>[]
                  ..add( DropdownMenuItem<String>(value: "m", child: Text("male".tr),))
                  ..add( DropdownMenuItem<String>(value: "f", child: Text("female".tr),)),
                onChanged: (value) {
                  value != null ? _valueGender = value : "";
                },
                decoration:  const InputDecoration(
                  border: OutlineInputBorder(                          // tổng
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
            ),
            CustomTextField(
                controller: _dateBirthDayTextController,
                padding: const EdgeInsets.only(top: 10),
                lable: "birth_day".tr,
                enabled: false,
                lastIcon: const Icon(Icons.calendar_month),
                onPressedLastIcon: _showCustomDialog
            ),
            CustomTextField(
              controller: _birthPlaceTextController,
              padding: const EdgeInsets.only(top: 10),
              lable: "birth_place".tr,
            ),
          ],
        )
      )
    );
  }

  _showCustomDialog(){
    Custom.showDialogCalendar(
        context: context,
        timeBirthday: _timeBirthday,
        dateBirthDayTextController: _dateBirthDayTextController
    ).then((value) {
      _timeBirthday = value;
    });
  }

  void updateUser(){
    UserController userController = Get.find<UserController>();
    User? currentUserProfile = userController.currentUserProfile;

    if(currentUserProfile != null){
      currentUserProfile.email = _emailTextController.text.toString();
      currentUserProfile.university = _universityTextController.text.toString();
      currentUserProfile.year = int.parse(_leverTextController.text);
      currentUserProfile.gender = _valueGender;
      currentUserProfile.dob = _timeBirthday?.formatToISOString();
      currentUserProfile.birthPlace = _birthPlaceTextController.text.toString();
      userController.updateUser()
          .then((value){
            showCustomSnackBar("update_success".tr, isError: false);
            Navigator.pop(context);
      }
          ).catchError((error) {
            showCustomSnackBar("update_failed".tr, isError: true);
      }
      );
    }else{
      showCustomSnackBar("not_found_user".tr, isError: true);
    }
  }
}
