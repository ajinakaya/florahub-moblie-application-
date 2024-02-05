
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

plantModel? productModelFromJson(String str) => plantModel.fromJson(json.decode(str));

String plantModelToJson(plantModel? data) => json.encode(data!.toJson());

class plantModel {
  plantModel({
    this.id,
    this.userId,
    this.plantId,
    this.pot,
    this.title,
    this.price,
    this.height,
    this.imageUrl,
    this.description,
    this.temperature,

  });

  String? id;
  String? userId;
  String? plantId;
  String? pot;
  String? title;
  String? price;
  String? height;
  String? temperature;
  String? description;
  String? imageUrl;


  factory plantModel.fromJson(Map<String, dynamic> json) => plantModel(
    id: json["id"],
    userId: json["user_id"],
    plantId: json["plantId"],
    pot: json["pot"],
    title: json["title"],
    height: json["height"],
    temperature: json["temperature"],
    price: json["price"].toDouble(),
    description: json["description"],
    imageUrl: json["imageUrl"],
  );



  factory plantModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => plantModel(
    id: json.id,
    userId: json["user_id"],
    plantId: json["plantId"],
    pot: json["pot"],
    title: json["title"],
    height: json["height"],
    temperature: json["temperature"],
    price: json["price"].toDouble(),
    description: json["description"],
    imageUrl: json["imageUrl"],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "plantId": plantId,
    "title": title,
    "pot": pot,
    "price": price,
    "description": description,
    "temperature": temperature,
    "imageUrl": imageUrl,
    "height": height,
  };
}
