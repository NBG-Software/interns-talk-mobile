import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart';

import '../../common/validators.dart';
import '../../utils/colors.dart';
import '../../utils/string.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isVisible =false;
  bool isObscured = true;

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            ChangePasswordEvent(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Change Password',
        style: Theme.of(context).textTheme.titleMedium,
      )),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: _currentPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !isVisible,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? Icon(CupertinoIcons.lock)
                            : Icon(CupertinoIcons.lock_slash)),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    iconColor: kIconColorGrey,
                    suffixPadding: EdgeInsets.only(right: 12),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.passwordValidator,
                    hintText: 'Current Password',
                    fillColor: kTextFieldContainer,
                    hintTextColor: kHintTextColor,
                  ),
                  CustomTextFormField(
                    controller: _newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isObscured,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                        icon: isVisible
                            ? Icon(CupertinoIcons.lock)
                            : Icon(CupertinoIcons.lock_slash)),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    iconColor: kIconColorGrey,
                    suffixPadding: EdgeInsets.only(right: 12),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.passwordValidator,
                    hintText: 'New Password',
                    fillColor: kTextFieldContainer,
                    hintTextColor: kHintTextColor,
                  ),
                  CustomTextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isObscured,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                        icon: isVisible
                            ? Icon(CupertinoIcons.lock)
                            : Icon(CupertinoIcons.lock_slash)),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    iconColor: kIconColorGrey,
                    suffixPadding: EdgeInsets.only(right: 12),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return kPasswordEmptyErrorText;
                      } else if (value.isNotEmpty &&
                          value != _newPasswordController.text) {
                        return kPasswordNotMatchErrorText;
                      }
                      return null;
                    },
                    hintText: 'Confirm Password',
                    fillColor: kTextFieldContainer,
                    hintTextColor: kHintTextColor,
                  ),
                  SizedBox(height: 60,),
                  BlocListener<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ChangePasswordSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password changed successfully!")),
                        );
                        Navigator.pop(context); // Close the page
                      } else if (state is ChangePasswordFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width / 1.2, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _changePassword,
                      child: Text('Change Password'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
