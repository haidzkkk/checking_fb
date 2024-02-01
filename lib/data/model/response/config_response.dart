class ConfigResponse {
  ConfigResponse({
    required this.versionName,
  });

  late final String versionName;

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    versionName = json['versionName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['versionName'] = versionName;
    return _data;
  }
}
