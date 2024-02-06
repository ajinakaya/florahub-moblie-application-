import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:florhub/Screen/Auth/forgetscreen.dart';
import 'package:florhub/Screen/Auth/loginscreen.dart';
import 'package:florhub/Screen/Auth/registerscreen.dart';
import 'package:florhub/Screen/dashboard/dashboard.dart';
import 'package:florhub/Screen/product/addplant.dart';
import 'package:florhub/Screen/product/editproduct.dart';
import 'package:florhub/Screen/product/plantlist.dart';
import 'package:florhub/Screen/product/plantdetails.dart';
import 'package:florhub/Screen/splash_screen.dart';
import 'package:florhub/services/localnotification.dart';
import 'package:florhub/viewmodels/auth_viewmodel.dart';
import 'package:florhub/viewmodels/categoryviewmodel.dart';
import 'package:florhub/viewmodels/global_ui_viewmodel.dart';
import 'package:florhub/viewmodels/product_viewmodel.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
         ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: OverlayKit(
        child: Consumer<GlobalUIViewModel>(builder: (context, loader, child) {

          return MaterialApp(
            title: 'flora hub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(

              fontFamily: "Poppins",
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.aBeeZeeTextTheme(),
            ),
            initialRoute: "/splash",
            routes: {
              "/login": (BuildContext context) => LoginScreen(),
              "/splash": (BuildContext context) => SplashScreen(),
              "/register": (BuildContext context) => RegisterScreen(),
              // "/forget-password": (BuildContext context) =>
              //     ForgetPasswordScreen(),
              "/dashboard": (BuildContext context) => DashboardScreen(),
              "/addproduct": (BuildContext context) => AddProductScreen(),
              "/edit-product": (BuildContext context) => EditProductScreen(),
              "/single-product": (BuildContext context) =>
                  plantdetailsScreen(),
              // "/single-category": (BuildContext context) =>
              //     CategoryProductsScreen(),
              "/my-products": (BuildContext context) => MyProductScreen(),
            },
          );
        }),
      ),
    );
  }
}
