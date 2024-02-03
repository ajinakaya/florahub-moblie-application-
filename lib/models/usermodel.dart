import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
UserModel? userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  String? id;
  String? fullname;
  String? userId;
  String? profilePic;
  String? email;
  String? password;
  String? username;
  String? fcm;



  UserModel({
    this.id,
    this.fullname,
    this.userId,
    this.profilePic,
    this. email,
    this.password,
    this.username,
    this.fcm,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    userId: json["user_id"],
    fullname: json["fullname"],
    username: json["username"],
    profilePic: json["profilePic"],
    email: json["email"],
    password: json["password"],
    fcm: json["fcm"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": fullname,
    "username": username,
    "profilePic": profilePic,
    "email": email,
    "password": password,
    "fcm": fcm,
  };
  factory UserModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => UserModel(
    id: json.id,
    userId: json["user_id"],
    fullname: json["fullname"],
    username: json["username"],
    profilePic: json["profilePic"],
    email: json["email"],
    password: json["password"],
    fcm: json["fcm"],
  );

}
