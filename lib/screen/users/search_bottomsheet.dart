import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/user_controller.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

import '../../data/model/body/user.dart';
import '../../utils/utils.dart';
import '../profile/profile_screen.dart';
import 'item_user.dart';
import 'item_user_loading.dart';

class SearchUserBottomSheet{

  static Future showBottomSearch(context){
    TextEditingController textEditingController = TextEditingController();

    List<User> users = Get.find<UserController>().users;
    RxList usersFind = <User>[].obs;
    RxBool isLoading = false.obs;
    RxString textSearch = "".obs;

    void findUser(String value) async{
      isLoading.value = true;
      usersFind.clear();
      await Future.delayed(const Duration(milliseconds: 1000));

      isLoading.value = false;
      if(value.isEmpty) return;
      for (var element in users) {
        if(element.displayName!.toLowerCase().contains(value.toLowerCase())){
          usersFind.add(element);
        }
      }
    }

    textEditingController.addListener(() {
      textSearch.value = textEditingController.text;
      findUser(textSearch.value);
    });

    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back_outlined),
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        hintText: "please_search".tr,
                        autofocus: true,
                        lastIcon: const Icon(Icons.search),
                        controller: textEditingController,
                        onPressedLastIcon: (){
                          findUser(textEditingController.text);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                    )
                  ],
                ),
                Obx(() =>  Visibility(
                    visible: textSearch.value.isNotEmpty,
                    child: Text("${"search_result_for".tr}: ${textSearch.value}")),
                ),
                Expanded(
                    child: Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.zero,
                        key: const PageStorageKey<String>("page-user"),
                        itemCount: isLoading.value ? 10 : usersFind.length,
                        itemBuilder: (context, index){
                          if(index < usersFind.length){
                            return ItemUser(
                              user: usersFind[index],
                              onPressed: (user){
                                if(user?.id != null){
                                  Utils.startScreen(ProfileScreen(userId: user!.id,));
                                }else{
                                  showCustomSnackBar("Không tim thấy user", isError: true);
                                }
                              },
                            );
                          }
                          return const ItemLoading();
                        },
                      ),
                    )
                )
              ],
            ),
          );
        }
    );
  }
}