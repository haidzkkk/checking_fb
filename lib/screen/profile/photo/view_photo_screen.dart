
import 'dart:io';
import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/screen/profile/photo/select_photo_screen.dart';

import '../../../controller/user_controller.dart';
import '../../../view/custom_snackbar.dart';

class ViewPhotoScreen extends StatefulWidget {
  UserController userController = Get.find<UserController>();
  String typeImage;

  ViewPhotoScreen({required this.typeImage, super.key});

  @override
  State<ViewPhotoScreen> createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {

  @override
  void initState() {
    super.initState();
    // tại sao delay 0 giây mà vẫn đợi build xong với thực thi:
    // Việc tạo Future mới này đảm bảo code bên trong sẽ được thực thi ở event loop tiếp theo.
    // Và event loop tiếp theo sẽ diễn ra sau khi widget build xong và pipeline render hoàn tất.
    Future.delayed(Duration.zero, () {
      navigateToSelecPhotoScreen();
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
      body: InkWell(
        onTap: (){
          navigateToSelecPhotoScreen();
        },
        child: GetBuilder<PhotoController>(builder: (photoController){
          double width = MediaQuery.of(context).size.width;
          if(photoController.selectedPhoto == null){
            return itemLoading(width);
          }
          return Stack(
            children: [
                SizedBox(
                  width: width,
                  height: width,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.file(
                      photoController.selectedPhoto!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return itemLoading(width);
                      },
                    )
                  ),
                ),
                Container(
                  width: width,
                  height: width,
                  color: Colors.black.withOpacity(0.7),
                ),
                SizedBox(
                  width: width,
                  height: width,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipOval(
                      child: Image.file(
                        photoController.selectedPhoto!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return itemLoading(width);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },),
      ),
    );
  }

  Widget itemLoading(double width){
    return Container(
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: width,
            color: Colors.grey.withOpacity(0.4),
          ),
          Icon(Icons.image, size: 100, color: Colors.white,),
        ],
      ),
    );
  }

  void _uploadImage() {
    String nameImage = "${widget.userController.currentUserProfile?.id}_${widget.typeImage}";

    Get.find<PhotoController>().uploadImageUrl(nameImage)
        .then((value) {
      switch(value){
        case 200 :
          showCustomSnackBar("Thành công", isError: false);
          Navigator.pop(context);
          break;
        case 400 :
          showCustomSnackBar("Kích thước quá cao");
          break;
        default:
          showCustomSnackBar("Kích thước quá cao");
          break;

      }
    })
        .catchError((error){
      showCustomSnackBar("Lỗi");
    });
  }

  void navigateToSelecPhotoScreen() {
    Get.to(SelectPhoto())?.then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
