import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/common/language_constants.dart';
import 'package:interns_talk_mobile/common/languages.dart';
import 'package:interns_talk_mobile/main.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translation(context).chooseLanguage,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: Languages.languageList().map((language) {
              return LanguageListTile(
                flag: language.flag,
                title: language.name,
                languageCode: language.languageCode,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class LanguageListTile extends StatefulWidget {
  const LanguageListTile({
    super.key,
    required this.flag,
    required this.title,
    required this.languageCode,
  });
  final String flag;
  final String title;
  final String languageCode;

  @override
  State<LanguageListTile> createState() => _LanguageListTileState();
}

class _LanguageListTileState extends State<LanguageListTile> {
  bool isSelected(BuildContext context) =>
      widget.languageCode == translation(context).localeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          isSelected(context) == true;
        });
        MyApp.setLocale(context, widget.languageCode);

        print('isSelected ${isSelected(context)}');
      },
      leading: Text(
        widget.flag,
        style: TextStyle(fontSize: 24),
      ),
      title: Text(widget.title),
      trailing: isSelected(context) ? Icon(Icons.check) : null,
    );
  }
}
