import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:florhub/models/plantmodel.dart';
import 'package:florhub/models/usermodel.dart';
import 'package:florhub/repositories/authrepositories.dart';
import 'package:florhub/services/firebase_service.dart';
import 'package:florhub/viewmodels/global_ui_viewmodel.dart';

import '../models/favoritemodel.dart';
import '../repositories/favoriterepository.dart';
import '../repositories/plantrepositories.dart';

class AuthViewModel with ChangeNotifier {
  int _a = 1;
  int get a => _a;

  addValue() {
    _a++;
  }

  User? _user = FirebaseService.firebaseAuth.currentUser;

  User? get user => _user;

  UserModel? _loggedInUser;
  UserModel? get loggedInUser => _loggedInUser;

  Future<void> login(String email, String password) async {
    try {
      var response = await AuthRepository().login(email, password);
      _user = response.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, _token);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthRepository().resetPassword(email);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> register(UserModel user) async {
    try {
      var response = await AuthRepository().register(user);
      _user = response!.user;
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, _token);
      notifyListeners();
    } catch (err) {
      AuthRepository().logout();
      rethrow;
    }
  }

  String? _token;
  String? get token => _token;
  Future<void> checkLogin(String? token) async {
    try {
      _loggedInUser = await AuthRepository().getUserDetail(_user!.uid, token);
      _token = token;
      notifyListeners();
    } catch (err) {
      _user = null;
      AuthRepository().logout();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await AuthRepository().logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  FavoriteRepository _favoriteRepository = FavoriteRepository();
  List<FavoriteModel> _favorites = [];
  List<FavoriteModel> get favorites => _favorites;

  List<plantModel>? _favoriteProduct;
  List<plantModel>? get favoriteProduct => _favoriteProduct;

  Future<void> getFavoritesUser() async {
    try {
      var response =
      await _favoriteRepository.getFavoritesUser(loggedInUser!.userId!);
      _favorites = [];
      for (var element in response) {
        _favorites.add(element.data());
      }
      _favoriteProduct = [];
      if (_favorites.isNotEmpty) {
        var productResponse = await ProductRepository()
            .getProductFromList(_favorites.map((e) => e.productId).toList());
        for (var element in productResponse) {
          _favoriteProduct!.add(element.data());
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
      _favorites = [];
      _favoriteProduct = null;
      notifyListeners();
    }
  }

  Future<void> favoriteAction(
      FavoriteModel? isFavorite, String productId) async {
    try {
      await _favoriteRepository.favorite(
          isFavorite, productId, loggedInUser!.userId!);
      await getFavoritesUser();
      notifyListeners();
    } catch (e) {
      _favorites = [];
      notifyListeners();
    }
  }

  List<plantModel>? _myProduct;
  List<plantModel>? get myProduct => _myProduct;

  Future<void> getMyProducts() async {
    try {
      var productResponse =
      await ProductRepository().getMyProducts(loggedInUser!.userId!);
      _myProduct = [];
      for (var element in productResponse) {
        _myProduct!.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }

  Future<void> addMyProduct(plantModel product) async {
    try {
      await ProductRepository().addProducts(product: product);

      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> editMyProduct(plantModel product, String productId) async {
    try {
      await ProductRepository()
          .editProduct(product: product, productId: productId);
      await getMyProducts();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> deleteMyProduct(String productId) async {
    try {
      await ProductRepository().removeProduct(productId, loggedInUser!.userId!);
      await getMyProducts();
      notifyListeners();
    } catch (e) {
      print(e);
      _myProduct = null;
      notifyListeners();
    }
  }
}
