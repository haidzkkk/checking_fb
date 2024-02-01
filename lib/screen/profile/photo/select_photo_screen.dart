
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timesheet/controller/photo_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/profile/photo/view_photo_screen.dart';

import '../../../controller/user_controller.dart';
import '../../../view/custom_snackbar.dart';

class SelectPhoto extends StatefulWidget {
  @override
  State<SelectPhoto> createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    Get.find<PhotoController>().getAlbumGallery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text("select photo", style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.white,
        child: GetBuilder<PhotoController>(
          builder: (photoController) {
            return GridView.builder(
                itemCount: photoController.assetList.isNotEmpty ? photoController.assetList.length : 18,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index){
                  if(photoController.assetList.isNotEmpty){
                    AssetEntity assetEntity = photoController.assetList[index];
                    return itemAsset(
                        data: assetEntity,
                        onPress: (value){
                          value.file.then((file) {
                                if(file != null && (file.lengthSync() / 1024 / 1024 < 1)){
                                  Get.find<PhotoController>().selectedPhoto = file;
                                  Navigator.pop(context);
                                }else{
                                  showCustomSnackBar("Ảnh lỗi, có thể do kích thước quá cao");
                                }
                              });

                        }
                    );
                  }else{
                    return ItemLoadingImage();
                  }
                }
            );
          }
        ),
      ),
    );
  }


  Widget itemAsset({required AssetEntity data, required Function(AssetEntity) onPress}) => InkWell(
    onTap: (){
      if(data.type != AssetType.video){
        onPress(data);
      }
    },
    child: Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: AssetEntityImage(
              data,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(250),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
        ),
        if (data.type == AssetType.video)
          const Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.video_camera_back_rounded,
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget ItemLoadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        margin: const EdgeInsets.all(2),
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Get.find<PhotoController>().resetImageSelect();
  }
}
