import 'package:flutter/material.dart';
import 'package:florhub/Screen/account/accountscreen.dart';
import 'package:florhub/Screen/cart/cart.dart';
import 'package:florhub/Screen/home/homepage.dart';
import '../favorite/favorite.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;

  _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _itemTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f4),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: <Widget>[HomeScreen(), FavoriteScreen(), CartScreen(), AccountScreen()],
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.blue),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          type: BottomNavigationBarType.fixed,
          onTap: _itemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
      ),
    );
  }
}
