
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:timesheet/data/repository/photo_repo.dart';
import 'package:timesheet/view/custom_snackbar.dart';

import '../data/api/api_checker.dart';

class PhotoController extends GetxController implements GetxService {
  final PhotoRepo repo;
  PhotoController({required this.repo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? selectedPhoto;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];

  void resetDataProfile(){
    albumList.clear();
    assetList.clear();
  }

  void resetImageSelect(){
    selectedPhoto = null;
  }

  Future getImageCamera(ImageSource imageSource) async{
    final ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: imageSource);
    if (image != null) {
      selectedPhoto = File(image.path);
    } else {
      // showCustomSnackBar("Không có ảnh");
    }
    return;
  }


  Future<int> uploadImageUrl(String nameImage) async {
    _isLoading = true;
    update();

    if(selectedPhoto == null || selectedPhoto!.lengthSync() / 1024 / 1024 > 1) return 400;
    print('Kích thước của file: ${(selectedPhoto!.lengthSync() / 1024 / 1024)} MB');

    Response response = await repo.uploadImageUrl(selectedPhoto!, nameImage);
    if(response.statusCode == 200){
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
    return response.statusCode!;
  }


  void getAlbumGallery() async {
    albumList = await repo.fetchAlbum(requestType: RequestType.common);
    assetList = await repo.loadAssets(selectedAlbum: albumList[0]);
    update();
  }

}