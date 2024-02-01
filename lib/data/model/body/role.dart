
class Role {
  int? id;
  String? name;
  String? authority;

  Role(this.id, this.name, this.authority);

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      json['id'],
      json['name'],
      json['authority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'authority': authority,
    };
  }
}