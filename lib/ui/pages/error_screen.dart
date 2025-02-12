import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String errorText;
  final String buttonText;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.errorText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Image.asset(
                  imagePath,
                  width: screenWidth / 1.8,
                  color: Theme.of(context).colorScheme.surface,
                  colorBlendMode: BlendMode.darken,
                  scale: 1.0,
                ),
                Text(
                  errorText,
                  textAlign: TextAlign.center,
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: Size(screenWidth / 1.2, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
