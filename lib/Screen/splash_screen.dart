import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:florhub/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../services/localnotification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthViewModel _authViewModel;

  void checkLogin() async{
    String? token = await FirebaseMessaging.instance.getToken();

    await Future.delayed(Duration(seconds: 1));
    // check for user detail first
    try{
      await _authViewModel.checkLogin(token);
      if(_authViewModel.user==null){
        Navigator.of(context).pushReplacementNamed("/login");
      }else{
        NotificationService.display(
          title: "Welcome back",
          body: "Hello ${_authViewModel.loggedInUser?.name},\n We have been waiting for you.",
        );
        Navigator.of(context).pushReplacementNamed("/dashboard");
      }
    }catch(e){
      Navigator.of(context).pushReplacementNamed("/login");
    }

  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    checkLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/Logo1.png")),
            const CircularProgressIndicator()
            ],
          ),
        ),
      );

  }
}