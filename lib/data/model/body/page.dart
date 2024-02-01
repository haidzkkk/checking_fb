import 'package:timesheet/data/model/body/user.dart';

class PageResponse<T>{
  List<T>? content;
  int? totalPages;
  int? totalElements;
  int? number;
  int? size;
  bool? first;
  bool? empty;

  PageResponse({
    this.content,
    this.totalPages,
    this.totalElements,
    this.number,
    this.size,
    this.first,
    this.empty,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
      return PageResponse(
        content:  (json['content'] as List<dynamic>?)?.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
        totalPages: json['totalPages'],
        totalElements: json['totalElements'],
        number: json['number'],
        size: json['size'],
        first: json['first'],
        empty: json['empty'],
      );

  }
}