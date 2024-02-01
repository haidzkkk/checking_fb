import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/users/item_user_loading.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_button.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import 'package:timesheet/view/custom_text_field.dart';

import '../../controller/user_controller.dart';
import '../../data/model/body/tracking.dart';
import '../../utils/utils.dart';
import '../../view/custom.dart';
import '../profile/profile_screen.dart';
import 'item_tracking.dart';

class TrackingScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TrackingScreenState();
  }
}

class TrackingScreenState extends State<TrackingScreen>{
  TrackingController trackingController = Get.find<TrackingController>();

  @override
  void initState() {
    trackingController.scrollController = ScrollController();
    super.initState();
    trackingController.getTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GetBuilder<TrackingController>(builder: (controller) {
        return RefreshIndicator(
            onRefresh: _onRefesh,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              key: controller.listTracking.isNotEmpty ? const PageStorageKey<String>("page-tracking") : null,
              itemCount: controller.listTracking.isNotEmpty ? controller.listTracking.length + 2 : 10,
              controller: trackingController.scrollController,
              itemBuilder: (builder, index) {
                if(index == 0) {
                  return itemHeaderTracking(context);
                }else if(index > controller.listTracking.length && controller.listTracking.isNotEmpty){
                  return itemFooterTracking(context);
                }else{
                  if(controller.listTracking.isNotEmpty) {
                    return ItemTracking(
                      tracking: controller.listTracking[index - 1],
                      onPressed: (tracking){
                        showAddTrackingBottomSheet(context, tracking: tracking);
                      },
                      onDelete: (tracking){
                        _deleteTracking(context, tracking);
                      },
                    );
                  }else{
                    return const ItemLoading();
                  }
                }
              },
              separatorBuilder: (BuildContext context, int index) => const Divider( ),
            )
        );
      }

      ),
    );
  }

  Future<void> _onRefesh() {
    return Get.find<TrackingController>().getTracking();
  }

  Widget itemHeaderTracking(BuildContext context) => Container(
    color: Colors.white,
    padding: EdgeInsets.only(top: 10),
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Custom.widgetAvatar(
            url: Get.find<UserController>().currentUser.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
            width: 40,
            height: 40,
            widthScreen: MediaQuery.of(context).size.width,
            onpress: (data){
              Utils.startScreen(ProfileScreen());
            }
        ),
        Expanded(
            child: InkWell(
              onTap: (){
                showAddTrackingBottomSheet(context);
              },
              child: CustomTextField(
                  enabled: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  lable: 'what_did_you_do'.tr),
            )
        ),
      ],
    ),
  );

  Widget itemFooterTracking(BuildContext context) => Container(
    width: 100,
    color: Colors.white,
    child: Column(
      children: [
        Text('no_follow'.tr, style: const TextStyle(fontSize: 24, ),),
        CustomButton(
            width: 200,
            buttonText: "add_now".tr,
            transparent: true,
            onPressed: (){
              showAddTrackingBottomSheet(context);
            })
      ],
    ),
  );

  Future showAddTrackingBottomSheet(BuildContext context, {Tracking? tracking}) {
    final TextEditingController textController = TextEditingController();
    RxDouble heightBottomSheet = 300.0.obs;
    textController.text = tracking?.content ?? "";

    List dataList = <String>[]
      ..add("success_job".tr)
      ..add("learn_new_skin".tr)
      ..add("support_colleagues".tr)
      ..add("pass_the_review".tr)
      ..add("complete_feature".tr)
      ..add("make_plan".tr);

    return showModalBottomSheet(context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsetsDirectional.only(top: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: const Icon(Icons.arrow_back_outlined),
                              onTap: (){ Navigator.pop(context);},
                            ),
                            Text("add_follow".tr, style: const TextStyle(fontSize: 22),),
                          ],
                        ),
                        CustomButton(
                          buttonText: tracking == null ? "post".tr : "edit".tr,
                          onPressed: () => tracking == null ? _postTracking(context, textController.text) : _updateTracking(context, tracking, textController.text),
                          width: 100, height: 30,)
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "what_did_you_do".tr
                        ),
                        style: const TextStyle(fontSize: 18),
                        maxLines: null,
                      ),
                    ),
                    Obx(() => SizedBox(
                      height: heightBottomSheet.value,
                      child: GestureDetector(
                        onTap: (){
                          if(heightBottomSheet.value == 100.0){
                            heightBottomSheet.value == 300.0;
                          }else{
                            heightBottomSheet.value == 100.0;
                          }
                        },
                        child: ListView.separated(
                          itemCount: dataList.length - 1,
                          itemBuilder: (builder, index) {
                            return GestureDetector(
                                onTap: (){
                                  textController.text = dataList[index];
                                },
                                child: Text(dataList[index], style: const TextStyle(fontSize: 18),));
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider( ),
                        ),
                      ),
                    )
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  _postTracking(context, String text){
    Get.find<TrackingController>().addTracking(text)
        .then((value) {
      if (value == 200 || value == 201){
        showCustomSnackBar("success".tr, isError: false, lable: "view".tr, onPressed: (){
          trackingController.scrollController?.animateTo(
              trackingController.scrollController!.position.maxScrollExtent,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut);
        });
        Navigator.pop(context);
      }
    });
  }

  _updateTracking(context, Tracking tracking, String text){
    Get.find<TrackingController>().updateTracking(tracking, text)
        .then((value) {
      if (value == 200 || value == 201){
        showCustomSnackBar("success".tr, isError: false, lable: "view".tr, onPressed: (){
          trackingController.scrollController?.animateTo(
              trackingController.scrollController!.position.maxScrollExtent,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut);
        });
        Navigator.pop(context);
      }
    });
  }

  _deleteTracking(context, Tracking? tracking){
    if(tracking != null){
      Get.find<TrackingController>().deleteTracking(tracking!)
          .then((value) {
        if (value == 200 || value == 201){
          showCustomSnackBar("success".tr, isError: false);
        }else{
          showCustomSnackBar("faild".tr, isError: false);
        }
      });
    }else{
      showCustomSnackBar("faild".tr, isError: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    trackingController.onDispose();
  }
}
