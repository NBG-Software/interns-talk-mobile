import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              color: kTextColor,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w300, color: kTextColor)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          onSurface: kAppBlack,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
