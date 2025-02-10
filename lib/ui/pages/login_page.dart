import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/ui/pages/register_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/dimens.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        height: 48,
                      ),
                      Text(
                        kWelcomeBodyText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: kEmailHintText,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.mail),
                              color: kIconColorGrey,
                            ),
                            hintStyle: TextStyle(color: kHintTextColor),
                            filled: true,
                            focusColor: kIconColorGrey,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kMarginMedium1x,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: kPasswordHintText,
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.lock_outline),
                              color: kIconColorGrey,
                            ),
                            hintStyle: TextStyle(color: kHintTextColor),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                      onPressed: () {},
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
