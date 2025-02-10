import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                      'Get Started',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    Text(
                      'by creating a free account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(color: kHintTextColor),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Second Name',
                                hintStyle: TextStyle(color: kHintTextColor),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: kMarginMedium1x,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Valid Email',
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
                          hintText: 'Strong Password',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.lock_outline),
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
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.lock_outline),
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
                      FilledButton(
                          onPressed: () {},
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
                    Text('Already have an account?'),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
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
