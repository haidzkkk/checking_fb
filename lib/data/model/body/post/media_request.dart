
import 'package:timesheet/data/model/body/post/comment.dart';
import 'package:timesheet/data/model/body/user.dart';

import '../../../../utils/app_constants.dart';
class MediaRequest{
  String name;
  bool isVideo;
  int contentSize;
  String contentType;
  String extension;
  String filePath;

  MediaRequest({
    required this.contentSize,
    required this.contentType,
    required this.extension,
    required this.filePath,
    required this.isVideo,
    required this.name,
  });

  factory MediaRequest.fromJson(Map<String, dynamic> json) {
    return MediaRequest(
      contentSize: json['contentSize'],
      contentType: json['contentType'],
      extension: json['extension'],
      filePath: json['filePath'],
      isVideo: json['isVideo'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentSize'] = contentSize;
    data['contentType'] = contentType;
    data['extension'] = extension;
    data['filePath'] = filePath;
    data['name'] = name;
    return data;
  }

  String getLinkImageUrl(){
    return "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}$name";
  }
}