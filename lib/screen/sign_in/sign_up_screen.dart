import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:get/get.dart';
import 'package:timesheet/data/model/body/role.dart';

import '../../controller/auth_controller.dart';
import '../../data/model/body/user.dart';
import '../../helper/date_converter.dart';
import '../../view/custom.dart';
import '../../view/custom_button.dart';
import '../../view/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _dateBirthDayTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _ussernameTextController = TextEditingController();
  final TextEditingController _paswordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController = TextEditingController();

  String _valueGender = "m";
  final _showPass = false.obs;
  DateTime? _timeBirthday = null;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<AuthController>(
                  builder: (controller) => Opacity(
                    opacity: controller.loading ? 0.3 : 1,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Text('register_account'.tr, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),),
                            ),
                            Row(
                              children: [
                                CustomTextField(
                                  controller: _lastNameTextController,
                                  padding: EdgeInsets.all(10),
                                  width: widthScreen / 2 - 20 - 10,
                                  lable: 'last_name'.tr,
                                ),
                                CustomTextField(
                                    controller: _firstNameTextController,
                                    padding: EdgeInsets.all(10),
                                    width: widthScreen / 2 - 20 - 10,
                                    lable: "first_name".tr
                                )
                              ],
                            ),
                            CustomTextField(
                                controller: _dateBirthDayTextController,
                                padding: EdgeInsets.all(10),
                                width: widthScreen,
                                lable: "birth_day".tr,
                                enabled: false,
                                lastIcon: Icon(Icons.calendar_month),
                                onPressedLastIcon: _showCustomDialog
                            ),
                            SizedBox(
                              height: 75,
                              child: DropdownButtonFormField(
                                value: _valueGender,
                                isDense: true,
                                padding:  EdgeInsets.all(10),
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
                              controller: _emailTextController,
                              padding: EdgeInsets.all(10),
                              width: widthScreen,
                              lable: "email",
                            ),
                            CustomTextField(
                              controller: _ussernameTextController,
                              padding: EdgeInsets.all(10),
                              width: widthScreen,
                              lable: "username".tr,
                            ),
                            Obx(() => CustomTextField(
                                controller: _paswordTextController,
                              lable: "password".tr,
                              padding: EdgeInsets.all(10),
                              isShowPass: _showPass.value,
                              lastIcon:  Icon(_showPass.value ? Icons.visibility : Icons.visibility_off),
                              onPressedLastIcon: () => _showPass.value = !_showPass.value
                            ),),
                            Obx(() =>      CustomTextField(
                              controller: _confirmPasswordTextController,
                              lable: "confirm_password".tr,
                              padding: EdgeInsets.all(10),
                              isShowPass: _showPass.value,
                            ),),
                            CustomButton(
                              width: double.infinity,
                              buttonText: "login".tr,
                              margin: const EdgeInsets.all(10),
                              onPressed: _login,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Center(
            child: GetBuilder<AuthController>(
              builder: (controller) => Visibility(
                  visible: controller.loading,
                  child: const CircularProgressIndicator()
              ),
            ),
          )
        ],
      ),
    );
  }

  _login() {
    String lastName = _lastNameTextController.text;
    String firstName = _firstNameTextController.text;
    String? dateBirthDay = _timeBirthday != null ? _timeBirthday!.formatToString(DateConverter.dateIso8601Format) : null;
    String? gender = _valueGender;
    String email = _emailTextController.text;
    String ussername = _ussernameTextController.text;
    String password = _paswordTextController.text;
    String confirmPassword = _confirmPasswordTextController.text;

    if(
        lastName.isEmpty || firstName.isEmpty || gender.isEmpty || email.isEmpty ||
        ussername.isEmpty || password.isEmpty || confirmPassword.isEmpty
    ){
      SnackBar snackBar = SnackBar(content: Text('cannot_left_blank'.tr));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      Get.find<AuthController>().signin(

        User(
            id: null,
          username: ussername,
          active: true,
          birthPlace: null,
          confirmPassword: confirmPassword,
          displayName: "$lastName $firstName",
          dob: dateBirthDay,
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
          changePass: true,
          setPassword: true,
          roles: <Role>[],
          countDayCheckin: 0,
          countDayTracking: 0,
          gender: gender,
          hasPhoto: false,
          tokenDevice: "",
          university: null,
          year: 0,
        )).then((value) {
          if (value == 200 || value == 201){
            SnackBar snackBar = SnackBar(content: Text('register_success'.tr));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Get.back();
          }
          else if (value == 400)
            {
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text("infomation_incorect".tr)));
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                  content: Text("please_try_again".tr)));
            }
        });
      }
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
}