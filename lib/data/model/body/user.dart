import 'dart:core';
import 'package:timesheet/data/model/body/role.dart';

import '../../../utils/app_constants.dart';

class User {
  int? id;
  String? username;
  bool? active;
  String? birthPlace;
  String? confirmPassword;
  String? displayName;
  String? dob;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  bool? changePass;
  bool? setPassword;
  List<Role>? roles;
  int? countDayCheckin;
  int? countDayTracking;
  String? gender;
  bool? hasPhoto;
  String? tokenDevice;
  String? university;
  int? year;

  User({
    this.id,
    this.username,
    this.active,
    this.birthPlace,
    this.confirmPassword,
    this.displayName,
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.changePass,
    this.setPassword,
    this.roles,
    this.countDayCheckin,
    this.countDayTracking,
    this.gender,
    this.hasPhoto,
    this.tokenDevice,
    this.university,
    this.year,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      active: json['active'],
      birthPlace: json['birthPlace'],
      confirmPassword: json['confirmPassword'],
      displayName: json['displayName'],
      dob: json['dob'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      changePass: json['changePass'],
      setPassword: json['setPassword'],
      roles: List<Role>.from(json['roles']?.map((e) => Role.fromJson(e))),
      countDayCheckin: json['countDayCheckin'],
      countDayTracking: json['countDayTracking'],
      gender: json['gender'],
      hasPhoto: json['hasPhoto'],
      tokenDevice: json['tokenDevice'],
      university: json['university'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'active': active,
      'birthPlace': birthPlace,
      'confirmPassword': confirmPassword,
      'displayName': displayName,
      'dob': dob,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'changePass': changePass,
      'setPassword': setPassword,
      'roles': roles?.map((role) => role.toJson()).toList(),
      'countDayCheckin': countDayCheckin,
      'countDayTracking': countDayTracking,
      'gender': gender,
      'hasPhoto': hasPhoto,
      'tokenDevice': tokenDevice,
      'university': university,
      'year': year,
    };
  }

  String getLinkImageUrl(String typeImage){
    return "${AppConstants.BASE_URL}${AppConstants.GET_IMAGE_BY_NAME}${id}_$typeImage.png";
  }
}
