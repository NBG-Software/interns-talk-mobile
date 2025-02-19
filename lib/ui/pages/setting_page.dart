import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/ui/pages/terms_page.dart';
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
          'Setting',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
            title: Text('Version'),
            trailing: Text(appVersion),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
            leading: Icon(CupertinoIcons.lock),
            title: Text('Change Password'),
            trailing: Icon(CupertinoIcons.forward),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TermsPage()));
            },
            leading: Icon(Icons.settings_outlined),
            title: Text('Terms and Conditions'),
            trailing: Icon(CupertinoIcons.forward),
          ),
        ],
      ),
    );
  }
}
