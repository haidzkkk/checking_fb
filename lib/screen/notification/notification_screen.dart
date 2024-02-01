
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notify_controller.dart';
import 'package:timesheet/screen/notification/item_notify.dart';
import 'package:timesheet/screen/users/item_user_loading.dart';

import '../../view/custom_text_field.dart';

class NotificationScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => NotificationScreenState();

}

class NotificationScreenState extends State<NotificationScreen>{

  @override
  void initState() {
    Get.find<NotifyController>().scrollController = ScrollController();
    super.initState();
    Get.find<NotifyController>().getNotify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: GetBuilder<NotifyController>(builder: (controller) =>
          RefreshIndicator(
              onRefresh: _onRefesh,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                key: controller.notifies.isNotEmpty ? const PageStorageKey<String>("page-tracking") : null,
                itemCount: controller.isLoading ? 10 : !controller.isLoading && controller.notifies.isEmpty ? 2 : controller.notifies.length + 1,
                controller: Get.find<NotifyController>().scrollController,
                itemBuilder: (builder, index) {
                  if(index == 0) {
                    return itemHeaderNotify();
                  }else if(!controller.isLoading && controller.notifies.isEmpty){
                    return itemNotifyEmpty();
                  }else if(!controller.isLoading && controller.notifies.isNotEmpty){
                    return ItemNotify(
                      notify: controller.notifies[index],
                      onPressed: (tracking){
                      },
                    );
                  }else{
                    return const ItemLoading();
                  }
                },
              )
          ),
      ),
    );
  }

  Future<void> _onRefesh() {
    return Get.find<NotifyController>().getNotify();
  }

  Widget itemHeaderNotify() => Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 2),
      child: Text("notificaiton".tr, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)
  );

  Widget itemNotifyEmpty() => Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 2),
      child: Center(child: Text("no_data".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))
  );

  @override
  void dispose() {
    Get.find<NotifyController>().onDispose();
    super.dispose();
  }

}