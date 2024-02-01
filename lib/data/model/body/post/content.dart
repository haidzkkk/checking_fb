import 'dart:ui';

import 'package:timesheet/data/model/body/post/comment.dart';

import '../../../../utils/utils.dart';
import '../user.dart';
import 'like.dart';
import 'media.dart';

class Content {
  int id;
  String content;
  int date;
  List<Like> likes;
  List<Comment> comments;
  List<Media> media;
  User user;
  late List<Color> listColor;

  Content({
    required this.content,
    required this.date,
    required this.id,
    required this.likes,
    required this.comments,
    required this.media,
    required this.user,
  }){
    listColor = Utils.getListColorRandom();
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      comments: json['comments'] == null ? [] : List<Comment>.from(json['comments'].map((comment) => Comment.fromJson(comment))),
      content: json['content'],
      date: json['date'],
      id: json['id'],
      likes: json['likes'] == null ? [] : List<Like>.from(json['likes']?.map((comment) => Like.fromJson(comment))),
      media: json['media'] == null ? [] : List<Media>.from(json['media']?.map((comment) => Media.fromJson(comment))),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['date'] = date;
    data['likes'] = likes.map((like) => like.toJson()).toList();
    data['comments'] = comments.map((comment) => comment.toJson()).toList();
    data['media'] = media.map((me) => me.toJson()).toList();
    data['user'] = user.toJson();
    return data;
  }

}
