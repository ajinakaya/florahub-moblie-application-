import 'package:flutter/material.dart';
import 'package:florhub/repositories/category_repositories.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  List<String> categoryNames = [];
  int selectId = -1;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      var categoryRepository = CategoryRepository();
      var categories = await categoryRepository.getCategories();
      setState(() {
        categoryNames =
            categories.map((doc) => doc.data()?.categoryName ?? "").toList();
      });
    } catch (error) {
      print("Error fetching categories: $error");
    }
  }

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
            Padding(
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
            ),


            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: categoryNames.asMap().entries.map((entry) {
                    final i = entry.key;
                    final categoryName = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectId = i;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              categoryName,
                              style: TextStyle(
                                color: selectId == i
                                    ? Colors.green
                                    : Colors.black.withOpacity(0.7),
                                fontSize: 16.0,
                              ),
                            ),
                            if (selectId == i)
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
            ),
          ],
        ),
      ),



      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        type: BottomNavigationBarType.fixed,
        onTap: _itemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
