import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/plantmodel.dart';

import '../services/firebase_service.dart';

class ProductRepository {
  CollectionReference<plantModel> productRef =
  FirebaseService.db.collection("plant").withConverter<plantModel>(
    fromFirestore: (snapshot, _) {
      return plantModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );

  Future<List<QueryDocumentSnapshot<plantModel>>> getAllProducts() async {
    try {
      final response = await productRef.get();
      var products = response.docs;
      return products;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<plantModel>>> getProductByCategory(
      String id) async {
    try {
      final response =
      await productRef.where("category_id", isEqualTo: id.toString()).get();
      var products = response.docs;
      return products;
    } catch (err) {
      print(err);
      rethrow;
    }
  }


  Future<List<QueryDocumentSnapshot<plantModel>>> getProductFromList(
      List<String> productIds) async {
    try {
      final response = await productRef
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      var products = response.docs;
      return products;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<plantModel>>> getMyProducts(
      String userId) async {
    try {
      final response =
      await productRef.where("user_id", isEqualTo: userId).get();
      var products = response.docs;
      return products;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool> removeProduct(String productId, String userId) async {
    try {
      final response = await productRef.doc(productId).get();
      if (response.data()!.userId != userId) {
        return false;
      }
      await productRef.doc(productId).delete();
      return true;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<plantModel>> getOneProduct(String id) async {
    try {
      final response = await productRef.doc(id).get();
      if (!response.exists) {
        throw Exception("Product doesn't exists");
      }
      return response;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<bool?> addProducts({required plantModel product}) async {
    try {
      final response = await productRef.add(product);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> editProduct(
      {required plantModel product, required String productId}) async {
    try {
      final response = await productRef.doc(productId).set(product);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool?> favorites({required plantModel product}) async {
    try {
      final response = await productRef.add(product);
      return true;
    } catch (err) {
      return false;
      rethrow;
    }
  }
}