import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final String? suffixIconPath;
  final AutovalidateMode? autovalidateMode;
  final Color? iconColor;
  final Color hintTextColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? suffixPadding;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.autovalidateMode,
    required this.hintText,
    this.fillColor,
    this.contentPadding,
    this.suffixPadding,
    this.suffixIconPath,
    this.iconColor,
    required this.hintTextColor,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: autovalidateMode,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        suffixIcon: suffixIconPath != null
            ? Padding(
                padding: suffixPadding ?? EdgeInsets.zero,
                child: Image.asset(
                  suffixIconPath!,
                  color: iconColor,
                ),
              )
            : null,
        filled: true,
        fillColor: fillColor,
        hintStyle: TextStyle(color: hintTextColor),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
