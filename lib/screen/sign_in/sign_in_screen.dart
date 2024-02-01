import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/screen/home_screen.dart';
import 'package:timesheet/screen/sign_in/sign_up_screen.dart';
import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/custom_button.dart';

import '../../view/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _showPass = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(height: 100,),
                      GetBuilder<AuthController>(
                        builder: (controller) => Opacity(
                          opacity: controller.loading ? 0.3 : 1,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(Images.logo, height: 100),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                                  child: Text('CHECKING', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal),),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: _usernameController,
                                        lable: 'username'.tr,
                                        textInputAction: TextInputAction.next,
                                        icon: const Icon(Icons.person),
                                        padding: const EdgeInsets.only(top: 10),
                                      ),
                                      Obx(() => CustomTextField(
                                          lable: "password".tr,
                                          textInputAction: TextInputAction.done,
                                          controller: _passwordController,
                                          padding: const EdgeInsets.only(top: 10),
                                          isShowPass: _showPass.value,
                                          icon: const Icon(Icons.lock),
                                          lastIcon:  Icon(_showPass.value ? Icons.visibility : Icons.visibility_off),
                                          onPressedLastIcon: () => _showPass.value = !_showPass.value
                                          ),
                                      ),
                                      CustomButton(
                                        width: double.infinity,
                                        buttonText: "login".tr,
                                        margin: const EdgeInsets.only(top: 30),
                                        onPressed: _login,
                                      ),
                                    Padding(
                                    padding: const EdgeInsets.all(20.0),
                                      child: RichText(
                                        text: TextSpan(
                                        style: TextStyle(fontSize: 14),
                                        children:  <TextSpan>[
                                        TextSpan(text: "${"no_account".tr} / ", style: const TextStyle(color: Colors.black)),
                                        TextSpan(
                                            text: "sign_up".tr,
                                            style: TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()..onTap = (){
                                              Get.to(const SignUpScreen(),
                                                  transition: Transition.rightToLeft,
                                                  duration: Duration(milliseconds: 500),
                                                  curve: Curves.easeIn);
                                            }
                                           ),
                                        ]
                                      ),
                                    ),
                                  )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Center(
              child: GetBuilder<AuthController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.loading,
                    child: const CircularProgressIndicator(),
                  );
                },
              )
            )
          ],
        )
    );
  }

  _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      SnackBar snackBar = SnackBar(
        content: Text('you_need_enter_your_acount'.tr),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Get.find<AuthController>().login(username, password).then((value) => {
            if (value == 200){
              Get.offAll(const HomeScreen(),transition: Transition.cupertinoDialog,duration: Duration(milliseconds: 500),curve: Curves.easeIn)
            }
            else if (value == 400)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("account_password_is_incorrect".tr)))
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("please_try_again".tr)))
              },
          });
    }
  }
}
