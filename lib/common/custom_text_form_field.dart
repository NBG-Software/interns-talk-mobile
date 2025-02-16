import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final Widget? suffixIcon;
  final AutovalidateMode? autoValidateMode;
  final Color? iconColor;
  final Color? hintTextColor;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? suffixPadding;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? obscuringCharacter;
  final bool? readOnly;
  final String? initialValue;


  const CustomTextFormField({
    Key? key,
    this.controller,
    this.readOnly,
    this.keyboardType,
    this.obscuringCharacter,
    this.autoValidateMode,
    this.hintText,
    this.initialValue,
    this.fillColor,
    this.obscureText,
    this.contentPadding,
    this.suffixPadding,
    this.suffixIcon,
    this.iconColor,
    this.hintTextColor,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly ?? false,
      validator: validator,
      initialValue: initialValue,
      obscureText : obscureText ?? false,
      keyboardType: keyboardType,
      obscuringCharacter: obscuringCharacter ?? '•',

      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        suffixIcon: suffixIcon,
        suffixIconColor: kIconColorGrey,
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
