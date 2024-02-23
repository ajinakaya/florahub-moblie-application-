import 'package:florhub/Class.dart';

import 'package:florhub/models/plantmodel.dart';
import 'package:florhub/repositories/plantrepositories.dart';
import 'package:florhub/services/firebase_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FirebaseService.db = FakeFirebaseFirestore();
  ProductRepository repo = ProductRepository();


  test("description", () async {
    var data = plantModel(
        price: 45,
        userId: "1",
        imageUrl: "",
        imagePath: "",
        id: "5",
        title: "test",
        categoryId: "5",
        pot:"3",
        temperature: "30",
        height: "30",
        description: "this is pant");
    final response = await repo.addProducts(product: data);

    expect(response, true);
  });
}