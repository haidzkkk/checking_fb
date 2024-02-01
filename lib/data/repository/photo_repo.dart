
import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class PhotoRepo{
  final ApiClient apiClient;
  PhotoRepo({required this.apiClient});

  Future<Response> uploadImageUrl(File file, String nameImage) async {
    return apiClient.postFileMultipartData(
        uri: AppConstants.UPLOAD_IMAGE,
        body: {},
        file: file,
        nameImage: nameImage);
  }

  Future fetchAlbum({required RequestType requestType}) async{
    List<AssetPathEntity> albumList = [];

    var permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth == true) {
      albumList = await PhotoManager.getAssetPathList(
        type: requestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future loadAssets({required AssetPathEntity selectedAlbum}) async{
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
      start: 0,
      // ignore: deprecated_member_use
      end: selectedAlbum.assetCount,
    );
    return assetList;
  }
}