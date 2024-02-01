import 'package:timesheet/data/model/body/post/sort.dart';

class PageablePost {
  int offset;
  int pageNumber;
  int pageSize;
  bool paged;
  Sort sort;
  bool unpaged;

  PageablePost({
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.sort,
    required this.unpaged,
  });

  factory PageablePost.fromJson(Map<String, dynamic> json) {
    return PageablePost(
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      paged: json['paged'],
      sort: Sort.fromJson(json['sort']),
      unpaged: json['unpaged'],
    );
  }
}
