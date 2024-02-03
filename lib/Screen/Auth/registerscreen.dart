import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:florhub/models/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:florhub/Widget/common_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/localnotification.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextPasswordConfirm = true;

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  void register() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    _ui.loadState(true);

    try {
      await _authViewModel.register(
        UserModel(
            email: _emailController.text,
            password: _passwordController.text,
            username: _usernameController.text,
            fullname: _fullnameController.text),
      );

      NotificationService.display(
        title: "Welcome to this app",
        body:
            "Hello ${_authViewModel.loggedInUser?.fullname},\n Thank you for registering in this application.",
      );

      Navigator.of(context).pushReplacementNamed("/dashboard");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _ui.loadState(false);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Register',
                  style: GoogleFonts.poppins(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Create a new account',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                CommonTextField(
                  controller: _fullnameController,
                  validator: ValidateSignup.fullname,
                  keyboardType: TextInputType.name,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintText: "Fullname",
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidateSignup.emailValidate,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintText: " email",
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextField(
                  controller: _usernameController,
                  validator: ValidateSignup.username,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.verified_user,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintText: 'Username',
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextField(
                  controller: _passwordController,
                  obscureText: _obscureTextPassword,
                  validator: (String? value) => ValidateSignup.password(
                      value, _confirmPasswordController),
                  prefixIcon: const Icon(
                    Icons.lock,
                    size: 22.0,
                    color: Colors.black,
                  ),
                  hintText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextPassword = !_obscureTextPassword;
                      });
                    },
                    child: Icon(
                      _obscureTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureTextPasswordConfirm,
                  validator: (String? value) =>
                      ValidateSignup.password(value, _passwordController),
                  prefixIcon: const Icon(
                    Icons.lock_clock,
                    size: 22.0,
                    color: Colors.black,
                  ),
                  hintText: 'Confirm Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextPasswordConfirm =
                            !_obscureTextPasswordConfirm;
                      });
                    },
                    child: Icon(
                      _obscureTextPasswordConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By signing you agree to our ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ' Terms of use',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'and ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      ' privacy notice',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 21,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side:
                                        const BorderSide(color: Colors.blue))),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(vertical: 20)),
                      ),
                      onPressed: () {
                        register();
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                SizedBox(
                  height: 21,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));

  }
}

class ValidateSignup {
  static String? fullname(String? value) {
    if (value == null || value.isEmpty) {
      return "fullName is required";
    }
    return null;
  }

  static String? emailValidate(String? value) {
    final RegExp emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!emailValid.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required";
    }
    return null;
  }

  static String? password(String? value, TextEditingController otherPassword) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password should be at least 8 character";
    }
    if (otherPassword.text != value) {
      return "Please make sure both the password are the same";
    }
    return null;
  }
}
