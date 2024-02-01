
import 'package:timesheet/data/model/body/user.dart';

class Tracking{
  int? id;
  String? content;
  String? date;
  User? user;

  Tracking({this.id, this.content, this.date, this.user});

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      id: json['id'],
      content: json['content'],
      date: json['date'],
      user: json['user'] != null ? User.fromJson(json['user']) : User(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['date'] = date;
    data['user'] = user?.toJson();
    return data;
  }
}
