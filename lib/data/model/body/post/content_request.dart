
import 'package:timesheet/data/model/body/post/media_request.dart';

import 'comment.dart';
import 'like.dart';
import 'media.dart';

class ContentRequest {
  String content;
  String date;
  List<Like> likes;
  List<Comment> comments;
  List<MediaRequest> media;

  ContentRequest({
    required this.content,
    required this.date,
    required this.likes,
    required this.comments,
    required this.media,
  });

  factory ContentRequest.fromJson(Map<String, dynamic> json) {
    return ContentRequest(
      content: json['content'],
      date: json['date'],
      likes: json['likes'] == null ? [] : List<Like>.from(json['likes']?.map((comment) => Like.fromJson(comment))),
      comments: json['comments'] == null ? [] : List<Comment>.from(json['comments'].map((comment) => Comment.fromJson(comment))),
      media: json['media'] == null ? [] : List<MediaRequest>.from(json['media']?.map((mediaRequest) => MediaRequest.fromJson(mediaRequest))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['date'] = date;
    data['likes'] = likes.isEmpty ? [] : likes.map((like) => like.toJson()).toList();
    data['comments'] = comments.isEmpty ? [] : comments.map((comment) => comment.toJson()).toList();
    data['media'] = media.isEmpty ? [] : media.map((me) => me.toJson()).toList();
    return data;
  }
}