
import 'dart:math';

import 'package:share_plus/share_plus.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/utils/utils.dart';

import '../../controller/post_controller.dart';
import '../../controller/user_controller.dart';
import '../../data/model/body/post/content.dart';
import '../../view/custom.dart';
import '../profile/profile_screen.dart';
import 'comment_bottomsheet.dart';

class ItemPostWall extends StatefulWidget{
  Content content;
  ItemPostWall({super.key, required this.content});

  @override
  State<StatefulWidget> createState() => ItemPostWallState();
}

class ItemPostWallState extends State<ItemPostWall> {
  Rx<bool> isLike = false.obs;
  double width = 0.0;
  double height = 0.0;

  @override
  Widget build(BuildContext context) {
    isLike.value = widget.content.likes.firstWhereOrNull((element) =>
    (element.user?.id ?? 0) == (Get.find<UserController>().currentUser.id ?? 0)) != null ? true : false;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        children: [
          layoutInfo(widget.content),
          layoutContent(widget.content),
          layoutContentDetail(widget.content),
        ],
      ),
    );
  }

  Widget layoutContent(Content content){

    return Container(
      width: width - 20,
      height: width - 120,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
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

    return InkWell(
      onTap: (){
        Utils.startScreen(ProfileScreen(userId: content.user.id,));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Custom.widgetAvatar(
                    height: 30,
                    width: 30,
                    widthScreen: width,
                    url: content.user.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                    onpress: (url){
                    }
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text("${content.user.displayName}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                )
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutContentDetail(Content content) {
    DateTime? currenDate;
    try{
      currenDate = DateTime.fromMillisecondsSinceEpoch(content.date);
    }catch(e){}

    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [


              InkWell(
                  onTap: (){
                    likePost(content.id.toString(), true);
                  },
                  child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: isLike.value
                          ? const Icon(Icons.favorite, color: Colors.red, size: 25,)
                          : const Icon(Icons.favorite_border, size: 25,)
                  ),),

              InkWell(
                  onTap: (){
                    CommentBottomSheet().showCommentBottomSheet(context, content, true);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(Icons.mode_comment_outlined, size: 25,)
                  ),),
              InkWell(
                  onTap: (){
                    Share.share(content.media.isNotEmpty ? content.media[0].getLinkImageUrl() : content.content);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(Icons.share_outlined, size: 25,)
                  ),
              ),
            ],
          ),
          Text("${content.likes.length} likes   ${content.comments.length} comments", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
          Visibility(
              visible: content.content.isNotEmpty,
              child: Text(content.content, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),)
          ),
          Visibility(
              visible: currenDate != null,
              child: Text(currenDate?.formatToStringTime() ?? "", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),)
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
