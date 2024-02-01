
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/screen/post/create_post_image_screen.dart';
import 'package:timesheet/screen/post/create_post_text_screen.dart';
import 'package:timesheet/screen/post/item_post_wall.dart';

import '../../utils/app_constants.dart';
import 'item_post.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  PostController postController = Get.find<PostController>();

  @override
  void initState() {
    postController.pageController = PageController();
    super.initState();
    postController.getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GetBuilder<PostController>(
            builder: (postController){
              return RefreshIndicator(
                onRefresh: () => postController.resetListPost(),
                child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: postController.posts.isEmpty ? 1 : postController.posts.length,
                    controller: postController.pageController,
                    onPageChanged: (index){
                      if (index >= postController.posts.length - 1) {
                        postController.getPost();
                      }
                    },
                    itemBuilder: (context, index) {
                      if(postController.posts.isEmpty){
                        return itemPostLoading();
                      }
                      return ItemPost(content: postController.posts[index]);
                    }
                ),
              );
            }
          ),
          const Positioned(
              top: 10,
              left: 10,
              child: Text("Posts", style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold, ),)
          ),
          Positioned(
              bottom: 5,
              child: layoutBottom()
          )
        ],
      ),
    );
  }

  Widget itemPostLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }

  Widget layoutBottom() {
    return Container(
      width: 250,
      height: 60,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: (){
                Get.to(CreatePostImageScreen(typeImage: AppConstants.TYPE_IMAGE_URL_POST_GALLERY,));
              },
              child: const Icon(Icons.image)
          ),
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.9),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: InkWell(
              onTap: (){
                Get.to(CreatePostImageScreen(typeImage: AppConstants.TYPE_IMAGE_URL_POST_CAM,));
              },
            ),
          ),
          InkWell(
              onTap: (){
                Get.to(CreatePostTextScreen());
              },
              child: const Icon(Icons.post_add)
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    postController.onDisPose();
  }
}
