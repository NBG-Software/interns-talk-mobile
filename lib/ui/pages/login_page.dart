import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/common/validators.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/chat_room_page.dart';
import 'package:interns_talk_mobile/ui/pages/forgot_password_page.dart';
import 'package:interns_talk_mobile/ui/pages/register_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/dimens.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
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
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  void _summitForm() {
    context.read<AuthBloc>().add(AuthLoginEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ));
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
                left: kMarginLarge, right: kMarginLarge, bottom: kMarginLarge),
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
                  height: 60,
                ),
                Column(
                  children: [
                    Text(
                      kWelcomeTitleText,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 52,
                    ),
                    Text(
                      kWelcomeBodyText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: 52,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        controller: _emailController,
                        suffixIcon: Image.asset(kEmailIcon),
                        iconColor: kIconColorGrey,
                        keyboardType: TextInputType.emailAddress,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: kEmailHintText,
                        validator: Validators.emailValidator,
                        fillColor: kTextFieldContainer,
                        hintTextColor: kHintTextColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixPadding: EdgeInsets.only(right: 12),
                      ),
                      SizedBox(
                        height: 52,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
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
                        validator: Validators.passwordValidator,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),

                        iconColor: kIconColorGrey,
                        suffixPadding: EdgeInsets.only(right: 12),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        hintText: kPasswordHintText,
                        keyboardType: TextInputType.visiblePassword,
                        fillColor: kTextFieldContainer,
                        hintTextColor: kHintTextColor,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: (){
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                              const ForgotPasswordPage()

                            )
                            );
                          },
                          child: Text(
                            kForgotPasswordText,
                            style: TextStyle(
                                color: kTextColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary),
                      minimumSize:
                          WidgetStatePropertyAll(Size(double.infinity, 52)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _summitForm();
                      }
                    },
                    child: Text(kLoginButtonText)),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(kDontHaveAccountText),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterPage()));
                      },
                      child: Text(
                        kRegisterButtonText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
