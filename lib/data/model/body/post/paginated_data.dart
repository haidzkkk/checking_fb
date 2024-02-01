
import 'package:timesheet/data/model/body/post/pageable_post.dart';
import 'package:timesheet/data/model/body/post/sort.dart';
import 'content.dart';

class PaginatedData {
  List<Content> content;
  bool empty;
  bool first;
  bool last;
  int number;
  int numberOfElements;
  PageablePost pageable;
  int size;
  Sort sort;
  int totalElements;
  int totalPages;

  PaginatedData({
    required this.content,
    required this.empty,
    required this.first,
    required this.last,
    required this.number,
    required this.numberOfElements,
    required this.pageable,
    required this.size,
    required this.sort,
    required this.totalElements,
    required this.totalPages,
  });

  factory PaginatedData.fromJson(Map<String, dynamic> json) {
    return PaginatedData(
      content: (json['content'] as List).map((c) => Content.fromJson(c)).toList(),
      empty: json['empty'],
      first: json['first'],
      last: json['last'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      pageable: PageablePost.fromJson(json['pageable']),
      size: json['size'],
      sort: Sort.fromJson(json['sort']),
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }
}
