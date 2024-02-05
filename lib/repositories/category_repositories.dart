import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
  FirebaseService.db.collection("categories").withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [

      CategoryModel(
        categoryName: "outdoor",
        status: "active",
      ),
      CategoryModel(
        categoryName: "All",
        status: "active",
      ),
      CategoryModel(
        categoryName: "Indoor",
        status: "active",
      ),
      CategoryModel(
        categoryName: "Office",
        status: "active",
      ),
      CategoryModel(
        categoryName: "Garden ",
        status: "active",
      ),
    ];
  }
}
