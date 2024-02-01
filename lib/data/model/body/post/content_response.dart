
import 'content.dart';

class ContentResponse{
  Content data;
  String? message;
  String? code;

  ContentResponse({
    required this.data,
    this.message,
    this.code,
  });

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
      data: Content.fromJson(json['data']),
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['data'] = data.toJson();
    map['message'] = message;
    map['code'] = code;
    return map;
  }
}