
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/view/custom_snackbar.dart';

import '../../view/custom_button.dart';
import '../../view/custom_text_field.dart';

class ChangePassProfileScreen extends StatefulWidget {
  const ChangePassProfileScreen({super.key});

  @override
  State<ChangePassProfileScreen> createState() => _ChangePassProfileScreenState();
}

class _ChangePassProfileScreenState extends State<ChangePassProfileScreen> {

  final TextEditingController _oldPaswordTextController = TextEditingController();
  final TextEditingController _newPaswordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController = TextEditingController();

  final _showPass = false.obs;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text("change_password".tr, style: const TextStyle(color: Colors.black),),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Obx(() => CustomTextField(
                  controller: _oldPaswordTextController,
                  lable: "old_password".tr,
                  padding: const EdgeInsets.only(top: 30),
                  isShowPass: _showPass.value,
                  lastIcon:  Icon(_showPass.value ? Icons.visibility : Icons.visibility_off),
                  onPressedLastIcon: () => _showPass.value = !_showPass.value
              ),),
              Obx(() => CustomTextField(
                  controller: _newPaswordTextController,
                  lable: "new_password".tr,
                  padding: const EdgeInsets.only(top: 10),
                  isShowPass: _showPass.value,
              ),),
              Obx(() => CustomTextField(
                controller: _confirmPasswordTextController,
                lable: "confirm_password".tr,
                padding: const EdgeInsets.only(top: 10),
                isShowPass: _showPass.value,
              ),),
              CustomButton(
                width: double.infinity,
                buttonText: "change_password".tr,
                height: 40,
                margin: const EdgeInsets.only(top: 30),
                onPressed: _updatePassWord,
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: CustomButton(
                  width: double.infinity,
                  buttonText: "cancel".tr,
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                ),
              ),
            ],
          ),
        )
    );
  }

  _updatePassWord() {
    UserController userController = Get.find<UserController>();
    String oldPass = _oldPaswordTextController.text;
    String newPass = _newPaswordTextController.text;
    String confirmPass = _confirmPasswordTextController.text;

    if(oldPass.isNotEmpty && newPass.isNotEmpty && confirmPass.isNotEmpty
        && (newPass == confirmPass)
    && userController.currentUserProfile != null){
      userController.currentUserProfile?.changePass = true;
      userController.currentUserProfile?.setPassword = true;
      userController.currentUserProfile?.password = newPass;

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
      showCustomSnackBar("cannot_left_blank".tr, isError: true);
    }
  }
}
