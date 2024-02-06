import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:florhub/models/plantmodel.dart';
import 'package:florhub/viewmodels/categoryviewmodel.dart';
import 'package:florhub/viewmodels/auth_viewmodel.dart';
import 'package:florhub/viewmodels/product_viewmodel.dart';

import '../../viewmodels/global_ui_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;
  late GlobalUIViewModel _ui;
  String? categoryId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      refresh();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _categoryViewModel.getCategories();
    _productViewModel.getProducts();
    _authViewModel.getMyProducts();
  }

  Future<void> getData() async {
    _ui.loadState(true);
    try {
      // Check if a category is selected
      if (categoryId != null) {
        // Fetch products based on the selected category
        await _categoryViewModel.getProductByCategory(categoryId!);
        print("Products fetched: ${_categoryViewModel.products}");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CategoryViewModel, AuthViewModel, ProductViewModel>(
      builder: (context, categoryVM, authVM, productVM, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Florhub",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                buildSearchBar(),

                // Categories
                buildCategories(),

                // Product Cards
                buildProductCards(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: Row(
        children: [
          Container(
            height: 45.0,
            width: 300.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                const SizedBox(
                  height: 45,
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                  ),
                ),
                Image.asset(
                  'assets/icon/search.png',
                  height: 25,
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
          ),
          Container(
            height: 43.0,
            width: 43.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.green,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.asset(
              'assets/icon/adjust.png',
              color: Colors.white,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Row(
          children: _categoryViewModel.categoryNames
              .asMap()
              .entries
              .map((entry) {
            final i = entry.key;
            final categoryName = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _categoryViewModel.selectId = i;
                    categoryId = _categoryViewModel.getCategoryIdByIndex(i);
                    getData(); // Fetch products based on the selected category
                  });
                },
                child: Column(
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                        color: _categoryViewModel.selectId == i
                            ? Colors.green
                            : Colors.black.withOpacity(0.7),
                        fontSize: 16.0,
                      ),
                    ),
                    if (_categoryViewModel.selectId == i)
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.green,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildProductCards() {
    return Column(
      children: _categoryViewModel.products.map((product) {
        return ProductCard(product);
      }).toList(),
    );
  }

  Widget ProductCard(plantModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        width: 250,
        child: Card(
          elevation: 5,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  e.imageUrl.toString(),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.title.toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        Text(
                          "Rs. " + e.price.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.green),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
