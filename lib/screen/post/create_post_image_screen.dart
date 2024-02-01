
import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/data/model/body/post/media.dart';
import 'package:timesheet/data/model/body/post/media_request.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/app_constants.dart';
import 'package:timesheet/view/custom_button.dart';

import '../../../controller/user_controller.dart';
import '../../../view/custom_snackbar.dart';
import '../../controller/post_controller.dart';
import '../../data/model/body/post/content_request.dart';
import '../profile/photo/select_photo_screen.dart';

class CreatePostImageScreen extends StatefulWidget {
  String typeImage;
  CreatePostImageScreen({required this.typeImage, super.key});

  final TextEditingController textController = TextEditingController();

  @override
  State<CreatePostImageScreen> createState() => _CreatePostImageScreenState();
}

class _CreatePostImageScreenState extends State<CreatePostImageScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if(widget.typeImage == AppConstants.TYPE_IMAGE_URL_POST_CAM){
        navigateToCamera();
      }else if(widget.typeImage == AppConstants.TYPE_IMAGE_URL_POST_GALLERY){
        navigateToSelecPhotoScreen();
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
        actions: [
          InkWell(
            onTap: _uploadImage,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Text("done".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),)
                )
            ),
          ),
        ],
        title: const Text("Preview profile picture", style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: widget.textController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Say some thing about this photo"
                    ),
                    maxLines: null,
                    style: const TextStyle(fontSize: 18, ),
                  ),
                ),
                GetBuilder<PhotoController>(builder: (photoController){
                  double width = MediaQuery.of(context).size.width;
                  if(photoController.selectedPhoto == null){
                    return itemLoading(width);
                  }
                  return Container(
                    width: width - 20,
                    height: width - 50,
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Image.file(
                      photoController.selectedPhoto!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return itemLoading(width);
                      },
                    ),
                  );
                },),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.pinkAccent.withOpacity(0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: InkWell(
                    onTap: (){
                      navigateToSelecPhotoScreen();
                    },
                    child: const Icon(Icons.image, size: 40, color: Colors.white,))),
                Expanded(child: InkWell(
                    onTap: (){
                      navigateToCamera();
                    },
                    child: const Icon(Icons.camera_alt, size: 40, color: Colors.white,))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemLoading(double width){
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Container(
        width: width,
        height: width,
        color: Colors.white,
      ),
    );
  }
  void navigateToSelecPhotoScreen() {
    Get.to(SelectPhoto())?.then((value) {
      setState(() {});
    });
  }

  void navigateToCamera() {
    Get.find<PhotoController>().getImageCamera(ImageSource.camera).then((value) {
      setState(() {});
    });
  }

  Widget buttonSelectImage({required IconData iconData, required Function onPress}) {
    return Expanded(
        child: InkWell(
          onTap: (){
            onPress();
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(40.0),
            ),
            margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30,),
            child: Center(
              child: Icon(iconData, size: 50,),
            ),
          ),
        )
    );
  }

  void _uploadImage() {
    String nameImage = "${DateTime.now().millisecond}_${widget.typeImage}";

    Get.find<PhotoController>().uploadImageUrl(nameImage)
        .then((value) {
      switch(value){
        case 200 || 201 :
          _createPostImage(nameImage);
          break;
        case 400 :
          showCustomSnackBar("Kích thước quá cao");
      }
    })
        .catchError((error){
      showCustomSnackBar("Lỗi");
    });
  }

  void _createPostImage(String imageName) {
    MediaRequest mediaRequest = MediaRequest(
      name: imageName,
      contentSize: 0,
      contentType: "string",
      extension: "string",
      filePath: "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}$imageName",
      isVideo: false,
    );

    Get.find<PostController>().createPost(
        ContentRequest(
            content: widget.textController.text,
            date: DateTime.now().formatToISOString(),
            likes: [],
            comments: [],
            media: [mediaRequest])
    ).then((value) {
      if(value == 200){
        showCustomSnackBar("Thành công", isError: false);
        Navigator.pop(context);
      }else{
        showCustomSnackBar("Thất bại");
      }
    })
        .catchError((error){
      print(error);
      showCustomSnackBar("Lỗi");
    });
  }

  @override
  void dispose() {
    super.dispose();
    Get.find<PhotoController>().resetImageSelect();
  }
}
