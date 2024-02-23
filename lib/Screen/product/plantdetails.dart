import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:florhub/models/favoritemodel.dart';
import 'package:florhub/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../repositories/cartrepositories.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/plantdetail_viewmodel.dart';

class PlantDetailsScreen extends StatefulWidget {
  const PlantDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PlantDetailsScreen> createState() => _plantdetailsScreenState();
}

class _plantdetailsScreenState extends State<PlantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
        create: (_) => SingleProductViewModel(), child: SingleProductBody());
  }
}

class SingleProductBody extends StatefulWidget {
  const SingleProductBody({Key? key}) : super(key: key);

  @override
  State<SingleProductBody> createState() => _SingleProductBodyState();
}

class _SingleProductBodyState extends State<SingleProductBody> {
  late SingleProductViewModel _singleProductViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singleProductViewModel = Provider.of<SingleProductViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
      await _singleProductViewModel.getProducts(productId);
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> favoritePressed(FavoriteModel? isFavorite, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Favorite updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }

  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer2<SingleProductViewModel, AuthViewModel>(
        builder: (context, singleProductVM, authVm, child) {
          return singleProductVM.product == null
              ? Scaffold(
            body: Container(
              child: Text("Error"),
            ),
          )
              : singleProductVM.product!.id == null
              ? Scaffold(
            body: Center(
              child: Container(
                child: Text("Please wait..."),
              ),
            ),
          )
              : Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 130,
                  left: 35,
                  child: Column(
                    children: [

                      Image.asset(
                        'assets/icon/temp.png',
                        height:45,
                        width: 45,

                      ),
                      SizedBox(height: 10),
                      Text(
                        singleProductVM.product!.temperature.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),


                Positioned(
                  bottom: 130,
                  left: 290,
                  child: Column(
                    children: [

                      Image.asset(
                        'assets/icon/pot.png',
                        height:45,
                        width: 45,

                      ),
                      SizedBox(height: 10),
                      Text(
                        singleProductVM.product!.pot.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 130,
                  left: 180,
                  child: Column(
                    children: [

                      Image.asset(
                        'assets/icon/height.png',
                        height:45,
                        width: 45,

                      ),
                      SizedBox(height: 10),
                      Text(
                        singleProductVM.product!.height.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 25,
                  left: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Rs. " + singleProductVM.product!.price.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      CartRepository().addToCart(singleProductVM.product!, 1).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cart updated")));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      fixedSize: Size(125, 60),
                    ),
                    child: Text("Add to cart"),
                  ),
                ),
              ],
            ),

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,

              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),

              actions: [
                Builder(builder: (context) {
                  FavoriteModel? isFavorite;
                  try {
                    isFavorite = authVm.favorites.firstWhere(
                            (element) => element.productId == singleProductVM.product!.id);
                  } catch (e) {}

                  return IconButton(
                      onPressed: () {
                        print(singleProductVM.product!.id!);
                        favoritePressed(isFavorite, singleProductVM.product!.id!);
                      },
                      icon: Icon(
                        Icons.favorite,

                        color: isFavorite != null ? Colors.red : Colors.grey,
                      )
                  );
                })
              ],
            ),

            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          singleProductVM.product!.imageUrl.toString(),
                          height: 300,
                          width: 500,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                singleProductVM.product!.title.toString(),
                                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 20),
                              Text(
                                singleProductVM.product!.description.toString(),
                                style: TextStyle(
                                  fontSize: 15,color: Colors.blueGrey
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                ],
              ),
            ),
          );
        });
  }
}