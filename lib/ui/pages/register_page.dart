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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                  decoration: BoxDecoration(
                  color: kTextFieldContainer,
                    borderRadius:  BorderRadius.circular(10.0),
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: kFirstName,
                          hintStyle: TextStyle(color: kHintTextColor),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child:Container(
                                decoration: BoxDecoration(
                                  color: kTextFieldContainer,
                                  borderRadius:  BorderRadius.circular(10.0),
                                ),
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: kSecondName,
                                        hintStyle: TextStyle(color: kHintTextColor),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: kMarginMedium1x,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kTextFieldContainer,
                          borderRadius:  BorderRadius.circular(10.0),
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: kMarginSmall2x,top: 3),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText:kValidEmailHint,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(kEmailIcon),
                                  color: kIconColorGrey,
                                ),
                                hintStyle: TextStyle(color: kHintTextColor),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kMarginMedium1x,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kTextFieldContainer,
                          borderRadius:  BorderRadius.circular(10.0),
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: kMarginSmall2x,top: 3),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: kStrongPasswordHint,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(kLockIcon),
                                  color: kIconColorGrey,
                                ),
                                hintStyle: TextStyle(color: kHintTextColor),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kMarginMedium1x,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: kTextFieldContainer,
                          borderRadius:  BorderRadius.circular(10.0),
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: kMarginSmall2x,top: 3),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: kConfirmPasswordHint,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(kLockIcon),
                                  color: kIconColorGrey,
                                ),
                                hintStyle: TextStyle(color: kHintTextColor),
                                border: InputBorder.none
                            ),
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
                    Text(kHaveAccountText),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
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
