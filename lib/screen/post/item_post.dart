
import 'dart:math';

import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/helper/notification_helper.dart';
import 'package:timesheet/screen/post/comment_bottomsheet.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/utils/utils.dart';

import '../../controller/user_controller.dart';
import '../../data/model/body/post/content.dart';
import '../../data/model/body/user.dart';
import '../../view/custom.dart';
import '../profile/profile_screen.dart';

class ItemPost extends StatefulWidget{
  ItemPost({super.key, required this.content});
  Content content;

  @override
  State<StatefulWidget> createState() => ItemPostState();

}

class ItemPostState extends State<ItemPost> {
  Rx<bool> isLike = false.obs;
  double width = 0.0;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    isLike.value = widget.content.likes.firstWhereOrNull((element) =>
    (element.user?.id ?? 0) == (Get.find<UserController>().currentUser.id ?? 0)) != null ? true : false;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        color: Material.of(context).color,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: (height / 2) - (width / 2) - 70,
              child: layoutContent(widget.content),
            ),
            Positioned(
                left: 15,
                bottom: 80,
                child: layoutContentDetail(widget.content),
            ),
            Positioned(
                right: 15,
                bottom: 80,
                child: layoutInfo(widget.content)
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutContent(Content content){
    return Container(
      width: width - 20,
      height: width - 50,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: content.listColor[0].withOpacity(0.2),
            spreadRadius: 200,
            blurRadius: 200,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: content.listColor[1].withOpacity(0.2),
            spreadRadius: 200,
            blurRadius: 200,
            offset: const Offset(0, 0),
          ),
        ],
        gradient: LinearGradient(
            colors: [content.listColor[0], content.listColor[1]],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
        ),
      ),
      child: Center(
        child: content.media.isNotEmpty
            ? FullScreenWidget(
              disposeLevel: DisposeLevel.High,
              child: Center(
                child: Hero(
                  tag: "${content.id}_image",
                  child: Image.network(
                      content.media.first.getLinkImageUrl(),
                      width: width,
                      height: width - 50,
                      fit: BoxFit.cover,
                    ),
                ),
              ),
            )
            : Text(content.content, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, ),),
      ),
    );
  }

  Widget layoutInfo(Content content) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            InkWell(
              onTap: (){
                Utils.startScreen(ProfileScreen(userId: content.user.id,));
              },
              child: Custom.widgetAvatar(
                  height: 50,
                  width: 50,
                  widthScreen: width,
                  url: content.user.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                  onpress: (url){
                    Utils.startScreen(ProfileScreen(userId: content.user.id,));
                  }
              ),
            ),
            const SizedBox(height: 20,),
            Obx(() => InkWell(
                onTap: (){
                  likePost(content.id.toString(), false);
                },
                child: isLike.value
                    ? const Icon(Icons.favorite, color: Colors.red, size: 40,)
                    : const Icon(Icons.favorite_border, size: 40,)
              ),
            ),
            Text("${content.likes.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            const SizedBox(height: 15,),
            InkWell(
                onTap: (){
                  CommentBottomSheet().showCommentBottomSheet(context, content, false);
                },
                child: const Icon(Icons.mode_comment_outlined, size: 40,)),
            Text("${content.comments.length}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            const SizedBox(height: 15,),
            InkWell(
                onTap: (){
                  Share.share(content.media.isNotEmpty ? content.media[0].getLinkImageUrl() : content.content);
                },
                child: const Icon(Icons.ios_share, size: 40,)
            ),
          ]
        ),
      ],
    );
  }

  Widget layoutContentDetail(Content content) {
    DateTime? currenDate;
    try{
      currenDate = DateTime.fromMillisecondsSinceEpoch(content.date);
    }catch(e){}

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
              visible: content.user.displayName != null || content.user.displayName != "",
              child: Text("${content.user.displayName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
          ),
          Visibility(
              visible: content.content != "",
              child: Text(content.content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
          ),
          Visibility(
              visible: currenDate != null,
              child: Text(currenDate?.formatToStringTime() ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
          ),
        ],
      ),
    );
  }
  
  void likePost(String postId, bool isPostByUser){
    isLike.value = !isLike.value;
    Get.find<PostController>().likePost(postId, isPostByUser);
  }
}
