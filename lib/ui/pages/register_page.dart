import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/common/validators.dart';
import 'package:interns_talk_mobile/data/repository/auth_repository.dart';
import 'package:interns_talk_mobile/ui/pages/chat_room_page.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/dimens.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthRepository();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _strongPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _summitForm() async {
    final response = await authService.remoteDS.signUp(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _strongPasswordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
    if (response.isSuccess) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ChatRoomPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.toString())));
      print('Error: ${response.error}');
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
                horizontal: kMarginLarge, vertical: kMarginLarge),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              controller: _firstNameController,
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
                        suffixIconPath: kEmailIcon,
                        iconColor: kIconColorGrey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        suffixIconPath: kLockIcon,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        iconColor: kIconColorGrey,
                        suffixPadding: EdgeInsets.only(right: 12),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        suffixIconPath: kLockIcon,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        iconColor: kIconColorGrey,
                        suffixPadding: EdgeInsets.only(right: 12),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(kHaveAccountText),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage()));
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
      )),
    );
  }
}
