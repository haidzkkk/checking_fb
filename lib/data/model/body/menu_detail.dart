
import 'package:flutter/cupertino.dart';

class MenuDetail{
  int _id;
  String? _title;
  Icon? _icon;

  MenuDetail(this._id, this._title, this._icon);

  int get id => _id;
  String? get title => _title;
  Icon? get icon => _icon;
}