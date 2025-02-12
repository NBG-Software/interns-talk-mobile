import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';
import 'package:interns_talk_mobile/ui/pages/chat_room_page.dart';
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
  final authService = AuthRepository();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _summitForm({
    required String email,
    required String password,
  }) async {
    final response = await authService.logIn(
      email: email,
      password: password,
    );
    if (response.isSuccess) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const ChatRoomPage();
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kMarginLarge, vertical: kMarginMedium1x),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Column(
                    children: [
                      Text(
                        kWelcomeTitleText,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        kWelcomeBodyText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                          controller: _emailController,
                          suffixIconPath: kEmailIcon,
                          iconColor: kIconColorGrey,
                          keyboardType: TextInputType.emailAddress,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          hintText: kEmailHintText,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return kEmailEmptyErrorText;
                            }
                            return null;
                          },
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
                          controller: _passwordController,
                          suffixIconPath: kLockIcon,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return kPasswordEmptyErrorText;
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          iconColor: kIconColorGrey,
                          suffixPadding: EdgeInsets.only(right: 12),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          hintText: kPasswordHintText,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          fillColor: kTextFieldContainer,
                          hintTextColor: kHintTextColor,
                        ),
                        SizedBox(
                          height: kMarginSmall1x,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            kForgotPasswordText,
                            style: TextStyle(
                                color: kTextColor,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _summitForm(
                              email: _emailController.text,
                              password: _passwordController.text);
                        }
                      },
                      child: Text(kLoginButtonText)),
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
      ),
    );
  }
}
