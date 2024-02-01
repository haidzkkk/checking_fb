
class Pageable{
  int pageIndex;
  int size;

  Pageable(this.pageIndex, this.size);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageIndex'] = pageIndex;
    data['size'] = size;
    return data;
  }
}