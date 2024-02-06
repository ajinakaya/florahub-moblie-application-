
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/plantmodel.dart';
import '../repositories/category_repositories.dart';
import '../repositories/plantrepositories.dart';

class CategoryViewModel with ChangeNotifier {
  CategoryRepository categoryRepository = CategoryRepository();
  ProductRepository _productRepository = ProductRepository();
  CategoryModel? _category = CategoryModel();
  CategoryModel? get category => _category;
  List<plantModel> _products = [];
  List<plantModel> get products => _products;
  List<String> categoryNames = [];
  int selectId = -1;
  List<String> categoryIds = [];

  Future<void> getCategories() async {
    try {
      var categories = await categoryRepository.getCategories();
      categoryNames =
          categories.map((doc) => doc.data()?.categoryName ?? "").toList();
      // Populate categoryIds
      categoryIds =
          categories.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (error) {
      print("Error fetching categories: $error");
      categoryNames = [];
      categoryIds = [];
      notifyListeners();
    }
  }

  Future<void> getProductByCategory(String categoryId) async{
    _category=CategoryModel();
    _products=[];
    notifyListeners();
    try{
      print(categoryId);
      var response = await categoryRepository.getCategory(categoryId);
      _category = response.data();
      var productResponse = await _productRepository.getProductByCategory(categoryId);
      for (var element in productResponse) {
        _products.add(element.data());
      }

      notifyListeners();
    }catch(e){
      _category = null;
      notifyListeners();
    }
  }

  String? getCategoryById(int index) {
    if (index >= 0 && index < categoryNames.length) {
      return categoryNames[index];
    }
    return null;
  }

  // Add a method to get the category ID based on the selected index
  String? getCategoryIdByIndex(int index) {
    if (index >= 0 && index < categoryIds.length) {
      return categoryIds[index];
    }
    return null;
  }
}
