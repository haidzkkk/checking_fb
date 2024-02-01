
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';

import '../../controller/post_controller.dart';
import '../../controller/user_controller.dart';
import '../../data/model/body/post/content.dart';
import '../../utils/app_constants.dart';
import '../../utils/utils.dart';
import '../../view/custom.dart';
import '../profile/profile_screen.dart';

class CommentBottomSheet{
  final TextEditingController textController = TextEditingController();

  Future showCommentBottomSheet(BuildContext context, Content content, bool isPostByUser ){
    return showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 5, width: 50, color: Colors.grey, margin: EdgeInsets.all(5),),
              const SizedBox(height: 10,),
              const Text("Comments", style: TextStyle(fontSize: 14, color: Colors.grey),),
              const Divider(),
              Expanded(
                child: GetBuilder<PostController>(
                  builder: (postController) {
                    Content? post;
                    if(isPostByUser){
                      post = postController.postsByUser.firstWhereOrNull((element) => element.id == content.id);
                    }else{
                      post = postController.posts.firstWhereOrNull((element) => element.id == content.id);
                    }

                    if(post == null || post.comments.isEmpty) return Container(child: const Center(child: Text("No any comments"),),);
                    List<Comment> comments = handleLogicComments(post);
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, indext){
                        return itemComment(context ,comments[indext]);
                      },
                    );
                  }
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
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
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "add this comment for ${content.user.displayName}",
                            hintMaxLines: 1,
                            // suffixIcon:
                        ),
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(fontSize: 16),
                        maxLines: null,
                        onFieldSubmitted: (string){
                          commentPost(content.id.toString(), string, isPostByUser);
                          // FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                            onTap: (){
                              commentPost(content.id.toString(), textController.text, isPostByUser);
                            },
                            child: const Icon(Icons.send))
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },);
  }

  Widget itemComment(BuildContext context, Comment comment) {
    DateTime? currenDate;
    try{
      currenDate = DateTime.fromMillisecondsSinceEpoch(comment.date);
    }catch(e){}

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Custom.widgetAvatar(
                  url: comment.user?.getLinkImageUrl(AppConstants.TYPE_IMAGE_URL_AVATAR),
                  width: 35,
                  height: 35,
                  widthScreen: MediaQuery.of(context).size.width,
                  onpress: (data){
                    Utils.startScreen(ProfileScreen(userId: comment.user?.id,));
                  }
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${comment.user?.displayName}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                  Visibility(
                      visible: comment.content != "",
                      child: Text(comment.content, style: const TextStyle(fontSize: 14),)
                  ),
                ],
              )
            ],
          ),
          Visibility(
              visible: currenDate != null,
              child: Text(currenDate?.formatToStringTime() ?? "", style: const TextStyle(fontSize: 12),)
          ),
        ],
      ),
    );
  }

  List<Comment> handleLogicComments(Content post) {
    List<Comment> comments = [];
    User currentUser = Get.find<UserController>().currentUser;
    post.comments.forEach((comment) {
      if(comment.user?.id == currentUser.id){
        comments.insert(0, comment);
      }else{
        comments.add(comment);
      }
    });
    return comments;
  }

  void commentPost(String postId, String comment, bool isPostByUser){
    if(comment == "") return;

    Get.find<PostController>().commentPost(postId, comment, isPostByUser)
    .then((value) {
      if(value == 200){
        textController.text = "";
      }
    });
  }

}