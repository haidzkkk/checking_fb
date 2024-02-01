
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/screen/post/item_post_wall.dart';
import 'package:timesheet/screen/profile/change_pass_profile_screen.dart';
import 'package:timesheet/screen/profile/edit_profile_screen.dart';
import 'package:timesheet/screen/profile/photo/select_photo_screen.dart';
import 'package:timesheet/screen/profile/photo/view_photo_screen.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_button.dart';

import '../../controller/user_controller.dart';
import '../../data/model/body/menu_detail.dart';
import '../../data/model/body/user.dart';
import '../../view/custom.dart';
import '../../view/custom_snackbar.dart';

class ProfileScreen extends StatefulWidget{
  int? userId;
  ProfileScreen({super.key, this.userId}){
    Get.find<UserController>().getCurrentUserProfile(userId);
    Get.find<UserController>().getCurrentUser();
    if(userId == null){
      Get.find<PostController>().getPostByUser();
    }else{
      // Get.find<PostController>().clearListPostByUser();
      Get.find<PostController>().isLastPageByUser = true;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return  ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>{
  final ScrollController _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(() {
      if(_scrollcontroller.position.maxScrollExtent == _scrollcontroller.offset){
        Get.find<PostController>().getPostByUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: Text("personal_info".tr, style: const TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.4),
        child: RefreshIndicator(
          onRefresh: _onRefesh,
          child: SingleChildScrollView(
            controller: _scrollcontroller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemHeader(),
                const SizedBox(height: 7,),
                itemInfoDetail(),
                const SizedBox(height: 7,),
                itemTracking(),
                const SizedBox(height: 7,),
                itemPostWall(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget itemHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.grey,
                  child: GetBuilder<UserController>(builder: (userController){
                    return Custom.widgetPhotoCover(
                      url: userController.currentUserProfile?.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_PHOTO_COVER),
                      width: double.infinity,
                      height: 200,
                    );
                  },),
                ),

                Positioned(
                    left: 30,
                    bottom: 0,
                    child: GetBuilder<UserController>(builder: (userController){
                      print(userController.currentUserProfile?.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR));
                      return Custom.widgetAvatar(
                        url: userController.currentUserProfile?.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                        width: 120,
                        height: 120,
                        widthScreen: MediaQuery.of(context).size.width,
                      );
                    },)
                ),
                Positioned(
                    left: 120,
                    bottom: 10,
                    child: GetBuilder<UserController>(builder: (controller){
                      return Visibility(
                        visible: controller.isMyProfile,
                        child: InkWell(
                          onTap: () {
                            showBottomMenu(
                              data: getMenuCamera(),
                              onPress: (id){
                                if(id == 3){
                                  Get.to(ViewPhotoScreen(typeImage: AppConstants.TYPE_IMAGE_URL_AVATAR,));
                                }else if(id == 4){
                                  Get.to(ViewPhotoScreen(typeImage: AppConstants.TYPE_IMAGE_URL_PHOTO_COVER,));
                                }
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      );
                    })
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: GetBuilder<UserController>(builder: (controller){
                return Text(controller.currentUserProfile?.displayName ?? "no_data".tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),);
              })
          ),
          GetBuilder<UserController>(builder: (controller){
            return Visibility(
              visible: controller.isAdmin || controller.isMyProfile,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: CustomButton(
                        buttonText: "edit".tr,
                        height: 40,
                        radius: 10,
                        icon: Icons.edit,
                        onPressed: (){
                          Get.to(const EditProfileScreen());
                        },
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_outlined),
                          onPressed: () {
                            showBottomMenu(
                                data: getMenuOption(controller.currentUserProfile?.active),
                                onPress: (id){
                                  if(id == 0){
                                    Get.to(const ChangePassProfileScreen());
                                  }else if (id == 1 || id == 2){
                                    controller.blockUser()
                                        .then((value){
                                      showCustomSnackBar("success".tr, isError: false);
                                    }
                                    ).catchError((error) {
                                      showCustomSnackBar("faild".tr, isError: true);
                                    }
                                    );
                                  }
                                }
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget itemInfoDetail() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("details".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          GetBuilder<UserController>(builder: (controller){
            var menuItems = convertUserToMenuDetail(controller.currentUserProfile);
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                itemBuilder: (context, index){
                  return itemMenuDetail(data: menuItems[index]);
                });
          },
          ),
        ],
      ),
    );
  }

  Widget itemTracking() {
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("check".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            GetBuilder<UserController>(builder: (controller){

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("attendance".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text("${controller.currentUserProfile?.countDayCheckin ?? "no_data".tr}", style: const TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("follow".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Text("${controller.currentUserProfile?.countDayTracking ?? "no_data".tr}", style: const TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                ],
              );
            }),

          ],
        )
    );
  }

  Widget itemPostWall() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bài viết", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10,),
          GetBuilder<PostController>(builder: (postController){
            return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: postController.isLastPageByUser ? postController.postsByUser.length : postController.postsByUser.length + 1,
                itemBuilder: (context, index){
                  if(index > postController.postsByUser.length - 1) return const SizedBox(height: 30, child: Center( child: CircularProgressIndicator(),),);
                  return ItemPostWall(content: postController.postsByUser[index],);
                },
              separatorBuilder: (BuildContext context, int index) => const Divider(),);
          }),
        ],
      ),
    );
  }

  Future<void> _onRefesh() {
    if(widget.userId == null){
      Get.find<PostController>().resetListPostByUser();
    }

    int? userId = Get.find<UserController>().currentUserProfile?.id;
    if(userId != null){
      return Get.find<UserController>().getCurrentUserProfile(userId);
    }
    return Future.error(Error());
  }

  Widget itemMenuDetail({ required MenuDetail data, Function? onPresss}){
    return InkWell(
      onTap: (){
        if(onPresss != null) onPresss();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            data.icon ?? const Icon(Icons.do_not_disturb_alt),
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("${data.title}")
            )
          ],
        ),
      ),
    );
  }

  List<MenuDetail> convertUserToMenuDetail(User? user){
    return <MenuDetail>[]
      ..add(MenuDetail(0, user?.active == true ? "active".tr : "no_active".tr, const Icon(Icons.beenhere)))
      ..add(MenuDetail(1, user?.email ?? "no_data".tr, const Icon(Icons.mail)))
      ..add(MenuDetail(2, user?.university ?? "no_data".tr, const Icon(Icons.school)))
      ..add(MenuDetail(3, "${user?.year ?? "no_data".tr}", const Icon(Icons.elevator)))
      ..add(MenuDetail(4, user?.gender == "M" ? "male".tr : user?.gender == "L" ? "female".tr : "no_data".tr, const Icon(Icons.transgender)))
      ..add(MenuDetail(5, user?.dob ?? "no_data".tr, const Icon(Icons.calendar_today)))
      ..add(MenuDetail(6, user?.birthPlace ?? "no_data".tr, const Icon(Icons.place)));
  }

  List<MenuDetail> getMenuOption(bool? active){
    List<MenuDetail> list = <MenuDetail>[]
      ..add(MenuDetail(0, "change_password".tr, const Icon(Icons.password)));

    if(active == true){
      list.add(MenuDetail(1, "block_user".tr, const Icon(Icons.block)));
    }else{
      list.add(MenuDetail(2, "unblock_user".tr, const Icon(Icons.block)));
    }

    return list;
  }

  List<MenuDetail> getMenuCamera(){
    return <MenuDetail>[]
      ..add(MenuDetail(3, "select_avatar".tr, const Icon(Icons.person_add_alt)))
      ..add(MenuDetail(4, "select_cover_photo".tr, const Icon(Icons.image)));
  }

  Future showBottomMenu({required List<MenuDetail> data, required Function(int) onPress}){
    return showModalBottomSheet(
        context: context,
        builder: (context) =>
            Container(
              margin: const EdgeInsets.all(10),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index){
                  return itemMenuDetail(
                      data: data[index],
                      onPresss: (){
                        Navigator.pop(context);
                        onPress(data[index].id);
                      });
                }, separatorBuilder: (BuildContext context, int index) => const Divider(),),
            )
    );
  }

  @override
  void dispose() {
    Get.find<UserController>().resetDataProfile();
    Get.find<PostController>().clearListPostByUser();
    super.dispose();
  }

}