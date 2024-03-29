import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cartmodel.dart';
import '../../models/favoritemodel.dart';
import '../../repositories/cartrepositories.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;

  List<CartItem> items = [];

  Future<void> getCartItems() async {
    final response = await CartRepository().getCart();
    setState(() {
      items = response.items;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCartItems();
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    });
    super.initState();
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> removeFavorite(FavoriteModel isFavorite, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please add to cart")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "shoppingcart",
            style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          child: RefreshIndicator(
            onRefresh: getInit,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: items == null
                  ? Column(
                children: [
                  Center(child: Text("Something went wrong")),
                ],
              )
                  : items.length == 0
                  ? Column(
                children: [
                  Center(child: Text("Please add to cart")),
                ],
              )
                  : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Builder(builder: (context) {
                      int total = 0;
                      num total_price = 0;
                      items.forEach((element) {
                        total += element.quantity;
                        total_price += (element.product.price ?? 0) * total;
                      });
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("Total Items : ${total.toString()}"),
                          ),
                          Container(
                            child: Text("Total Price : ${total_price.toString()}"),
                          ),
                        ],
                      );
                    }),
                  ),
                  ...items.map(
                        (e) => InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/single-product", arguments: e.product.id!);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),

                          ),
                          child: ListTile(
                            trailing: IconButton(
                              iconSize: 25,
                              onPressed: () {
                                CartRepository().removeItemFromCart(e.product).then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text("Cart updated")));
                                  getCartItems();
                                });
                              },
                              icon: Icon(
                                Icons.delete_outlined,
                                color: Colors.red,
                              ),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                e.product.imageUrl.toString(),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(e.product.title.toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.product.price.toString()),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CartRepository()
                                            .removeFromCart(e.product)
                                            .then((value) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Cart updated")));
                                          getCartItems();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFE6F0F5),
                                            borderRadius: BorderRadius.circular(50)),
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.remove,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Text(e.quantity.toString()),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CartRepository()
                                            .addToCart(e.product, 1)
                                            .then((value) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Cart updated")));
                                          getCartItems();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFE6F0F5),
                                            borderRadius: BorderRadius.circular(50)),
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.add,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
