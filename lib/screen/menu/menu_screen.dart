
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/controller/notify_controller.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/data/model/language_model.dart';
import 'package:timesheet/screen/profile/profile_screen.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_button.dart';

import '../../controller/localization_controller.dart';
import '../../helper/route_helper.dart';
import '../../theme/theme_controller.dart';
import '../../utils/utils.dart';
import '../../view/custom.dart';
import '../sign_in/sign_in_screen.dart';

class MenuScreen extends StatelessWidget{
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<UserController>().getCurrentUser();

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 2),
              child: Text("setting".tr, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)
          ),
          GetBuilder<UserController>(builder: (controller) =>
              InkWell(
                onTap: (){
                  Utils.startScreen(ProfileScreen());
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, spreadRadius: 0),
                    ],
                  ),
                  child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child:  Custom.widgetAvatar(
                              url: controller.currentUser.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                              width: 40,
                              height: 40,
                              widthScreen: MediaQuery.of(context).size.width,
                              onpress: (data){
                                Utils.startScreen(ProfileScreen());
                              }
                          )
                        ),
                        Text("${controller.currentUser.displayName}", style: const TextStyle(fontSize: 18),)
                      ]
                  ),
                ),
              )
          ),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.grey, spreadRadius: 0),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_mode , size: 35,),
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text('mode'.tr, style: const TextStyle(fontSize: 16),)
                          )
                        ],
                      ),
                      GetBuilder<ThemeController>(builder: (themeController) {
                        return SizedBox(
                          height: 35,
                          child: LiteRollingSwitch(
                            value: themeController.darkTheme ?? false,
                            width: 70,
                            textOn: '',
                            textOff: '',
                            textOnColor: Colors.white,
                            textOffColor: Colors.white,
                            colorOn: Colors.purple,
                            colorOff: Colors.amber,
                            iconOn: Icons.nightlight_round_outlined,
                            iconOff: Icons.sunny,
                            animationDuration: const Duration(milliseconds: 100),
                            onTap: (){},
                            onDoubleTap: (){},
                            onSwipe: (){},
                            onChanged: (value) {
                              themeController.toggleTheme();
                            },
                          ),
                        );
                      },),
                    ],
                  ),
                  const Divider(),
                  InkWell(
                    onTap: (){
                      showBottomSheetLanguage(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.translate , size: 35,),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text('language'.tr, style: const TextStyle(fontSize: 16),)
                            )
                          ],
                        ),
                        GetBuilder<LocalizationController>(builder: (localizeController){
                          switch(localizeController.locale.languageCode){
                            case "en" : return Text('english'.tr);
                            case "vi" : return Text('vietnamese'.tr);
                            default : return const Text("NaN");
                          }
                        }),
                      ],
                    ),
                  )
                ],
              )
          ),
          CustomButton(
            buttonText: "Đăng xuất",
            onPressed: (){
              Get.find<AuthController>().logOut()
              .then((value) {
                // Get.deleteAll();
                Get.offAllNamed(RouteHelper.signIn);
              });
            },
          ),
        ],
      ),
    );
  }

  Future showBottomSheetLanguage(BuildContext context){
    List<LanguageModel> languages = AppConstants.languages;

    return showModalBottomSheet(context: context, builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.horizontal_rule),
          GetBuilder<LocalizationController>(
            builder: (localeController) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      localeController.setLanguage(Locale(languages[index].languageCode, languages[index].countryCode));
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  languages[index].imageUrl,
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(languages[index].languageName),
                            ],
                          ),
                          Radio(
                            onChanged: (value){},
                            groupValue: true,
                            value: localeController.locale.languageCode.endsWith(languages[index].languageCode),
                          )
                        ],
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) => const Divider(),
              );
            },
          ),
        ],
      );
    });
  }

}