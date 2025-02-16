import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/common/validators.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/chat_room_page.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/dimens.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _BodyView();
      }, listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatRoomPage()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }),
    );
  }
}

class _BodyView extends StatefulWidget {
  const _BodyView();

  @override
  State<_BodyView> createState() => __BodyViewState();
}

class __BodyViewState extends State<_BodyView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _strongPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool isObscured = true;

  Future<void> _summitForm() async {
    context.read<AuthBloc>().add(AuthSignUpEvent(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _strongPasswordController.text,
        confirmPassword: _confirmPasswordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: kMarginLarge, right: kMarginLarge, bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(kAppLogoImage),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(kAppName),
                ],
              ),
              SizedBox(
                height: 52,
              ),
              Column(
                children: [
                  Text(
                    kRegisterTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    kRegisterBodyText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _firstNameController,
                            keyboardType: TextInputType.text,
                            autoValidateMode: AutovalidateMode.onUnfocus,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return kFirstNameErrorText;
                              }
                              return null;
                            },
                            hintText: kFirstNameHint,
                            hintTextColor: kHintTextColor,
                            fillColor: kTextFieldContainer,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: CustomTextFormField(
                            autoValidateMode: AutovalidateMode.onUnfocus,
                            keyboardType: TextInputType.text,
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return kLastNameErrorText;
                              }
                              return null;
                            },
                            hintText: kLastNameHint,
                            hintTextColor: kHintTextColor,
                            fillColor: kTextFieldContainer,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: kMarginMedium1x,
                    ),
                    CustomTextFormField(
                      controller: _emailController,
                      suffixIcon:Image.asset(kEmailIcon),
                      keyboardType: TextInputType.emailAddress,
                      iconColor: kIconColorGrey,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: Validators.emailValidator,
                      hintText: kValidEmailHint,
                      fillColor: kTextFieldContainer,
                      hintTextColor: kHintTextColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      suffixPadding: EdgeInsets.only(right: 12),
                    ),
                    SizedBox(
                      height: kMarginMedium1x,
                    ),
                    CustomTextFormField(
                      controller: _strongPasswordController,
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
                      hintText: kStrongPasswordHint,
                      fillColor: kTextFieldContainer,
                      hintTextColor: kHintTextColor,
                    ),
                    SizedBox(
                      height: kMarginMedium1x,
                    ),
                    CustomTextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText:isObscured,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                          icon: !isObscured
                              ? Icon(CupertinoIcons.lock)
                              : Icon(CupertinoIcons.lock_slash)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      iconColor: kIconColorGrey,
                      suffixPadding: EdgeInsets.only(right: 12),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return kPasswordNotMatchErrorText;
                        } else if (value.isNotEmpty &&
                            value != _strongPasswordController.text) {
                          return kPasswordNotMatchErrorText;
                        }
                        return null;
                      },
                      hintText: kConfirmPasswordHint,
                      fillColor: kTextFieldContainer,
                      hintTextColor: kHintTextColor,
                    ),
                    SizedBox(
                      height: kMarginMedium1x,
                    ),
                    FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _summitForm();
                          }
                        },
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            minimumSize: WidgetStatePropertyAll(
                                Size(double.infinity, 52))),
                        child: Text(kRegisterButtonText)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(kHaveAccountText),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()),
                            (route)=>false);
                      },
                      child: Text(
                        kLoginButtonText,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
