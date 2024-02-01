
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/screen/users/search_bottomsheet.dart';
import 'package:timesheet/view/custom_snackbar.dart';
import '../../controller/user_controller.dart';
import '../../utils/utils.dart';
import '../../view/custom_text_field.dart';
import '../profile/profile_screen.dart';
import 'item_user.dart';
import 'item_user_loading.dart';

class UsersScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UsersScreen>{
  final userController  = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.scrollController = ScrollController();
    userController.restartListUser();
    userController.scrollController?.addListener(() {
      if(userController.scrollController?.position.maxScrollExtent == userController.scrollController?.offset){
        userController.getListUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: RefreshIndicator(
        onRefresh: _onRefesh,
        child: GetBuilder<UserController>(builder: (controller) =>
            ListView.builder(
              padding: EdgeInsets.zero,
              key: const PageStorageKey<String>("page-user"),
              controller: userController.scrollController,
              itemCount: controller.users.length + (controller.isLastPage ? 1 : 5),
              itemBuilder: (context, index){
                if(index == 0){
                  return itemHeaderUsers(context, controller.users.length);
                }else if(index < controller.users.length + 1){
                  return ItemUser(
                    user: controller.users[index - 1],
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
        ),
      ),
    );
  }

  Future<void> _onRefesh() {
    return Get.find<UserController>().restartListUser();
  }

  Widget itemHeaderUsers(BuildContext context, int sizeUsers) => GestureDetector(
    onTap: (){
    },
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("list".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),),
              RichText(
                text: TextSpan(
                    style: const TextStyle(fontSize: 22),
                    children:  <TextSpan>[
                      TextSpan(text: "total_user".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black)),
                      TextSpan(text: " $sizeUsers", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red),),
                    ]
                ),
              ),
            ],
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: RawMaterialButton(
                fillColor: Colors.grey.withOpacity(0.6),
                onPressed: (){
                  SearchUserBottomSheet.showBottomSearch(context);
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.search)
            ),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    userController.onDispose();
    super.dispose();
  }
}