import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  CommonTextField({
    Key? key,
    this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText!,
      validator: widget.validator,
      style: const TextStyle(
        fontFamily: 'WorkSansSemiBold',
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'WorkSansSemiBold',
          fontSize: 17.0,
        ),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
