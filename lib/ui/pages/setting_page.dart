import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/common/language_constants.dart';
import 'package:interns_talk_mobile/ui/pages/language_page.dart';
import 'package:interns_talk_mobile/ui/pages/terms_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'change_password_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          translation(context).settingTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangeLanguagePage()));
                },
                child: Icon(Icons.language),
                style: ButtonStyle(
                    iconColor: WidgetStatePropertyAll(
                      kIconOutlineColor,
                    ),
                    iconSize: WidgetStatePropertyAll(24)),
              )),
        ],
      ),
      body: _BodyView(),
    );
  }
}

class _BodyView extends StatefulWidget {
  const _BodyView();

  @override
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  bool isActive = false;
  String appVersion = "Loading...";

  Future<void> loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text(translation(context).version),
            trailing: Text(appVersion),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
            leading: Icon(CupertinoIcons.lock),
            title: Text(translation(context).changePasswordTitle),
            trailing: Icon(CupertinoIcons.forward),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TermsPage()));
            },
            leading: Icon(Icons.settings_outlined),
            title: Text(translation(context).terms),
            trailing: Icon(CupertinoIcons.forward),
          ),
        ],
      ),
    );
  }
}
