import 'package:flutter/cupertino.dart';
import 'package:florhub/models/plantmodel.dart';
import '../repositories/plantrepositories.dart';

class ProductViewModel with ChangeNotifier {
  ProductRepository _productRepository = ProductRepository();
  List<plantModel> _products = [];
  List<plantModel> get products => _products;

  List<plantModel> _categoryProducts = [];
  List<plantModel> get categoryProducts => _categoryProducts;

  Future<void> getProducts() async {
    _products = [];
    notifyListeners();
    try {
      var response = await _productRepository.getAllProducts();
      for (var element in response) {
        print(element.id);
        _products.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _products = [];
      notifyListeners();
    }
  }

  Future<void> addProduct(plantModel product) async {
    try {
      var response = await _productRepository.addProducts(product: product);
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> getProductsByCategory(String categoryId) async {
    _categoryProducts = [];
    notifyListeners();
    try {
      var response = await _productRepository.getProductByCategory(categoryId);
      for (var element in response) {
        _categoryProducts.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _categoryProducts = [];
      notifyListeners();
    }
  }
}
