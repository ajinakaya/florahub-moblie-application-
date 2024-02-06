
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

plantModel? productModelFromJson(String str) => plantModel.fromJson(json.decode(str));

String plantModelToJson(plantModel? data) => json.encode(data!.toJson());

class plantModel {
  plantModel({
    this.id,
    this.userId,
    this.categoryId,
    this.pot,
    this.title,
    this.price,
    this.height,
    this.imageUrl,
    this.description,
    this.temperature,
    this.imagePath,

  });

  String? id;
  String? userId;
  String? categoryId;
  String? pot;
  String? title;
  num? price;
  String? height;
  String? temperature;
  String? description;
  String? imageUrl;
  String? imagePath;


  factory plantModel.fromJson(Map<String, dynamic> json) => plantModel(
    id: json["id"],
    userId: json["user_id"],
    categoryId: json["category_id"],
    pot: json["pot"],
    title: json["title"],
    height: json["height"],
    temperature: json["temperature"],
    price: json["price"].toDouble(),
    description: json["description"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );



  factory plantModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => plantModel(
    id: json.id,
    userId: json["user_id"],
    categoryId: json["category_id"],
    pot: json["pot"],
    title: json["title"],
    height: json["height"],
    temperature: json["temperature"],
    price: json["price"].toDouble(),
    description: json["description"],
    imageUrl: json["imageUrl"],
    imagePath: json["imagePath"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "category_id": categoryId,
    "title": title,
    "pot": pot,
    "price": price,
    "description": description,
    "temperature": temperature,
    "imageUrl": imageUrl,
    "height": height,
    "imagePath": imagePath,
  };
}
