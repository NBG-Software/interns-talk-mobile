import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interns_talk_mobile/utils/images.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: _BodyView(),
    );
  }
}

class _BodyView extends StatelessWidget {
  const _BodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://framerusercontent.com/images/XMW8cln5SZReUZI5zimRfTIBA.jpg',
                scale: 1.0,
                width: 148,
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                child: Row(
                  children: [
                    Image.asset(kUploadIcon),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Upload'),
                  ],
                ),
              ),
              SizedBox(
                height: 52,
              ),
              ListTile(
                leading: Icon(CupertinoIcons.person_circle),
                title: Text('Edit Profile'),
                trailing: Icon(CupertinoIcons.forward),
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Setting'),
                trailing: Icon(CupertinoIcons.forward),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.headphones),
                title: Text('Help Center'),
                trailing: Icon(CupertinoIcons.forward),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 64),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              onPressed: () {},
              child: Text('Log Out'),
            ),
          )
        ],
      ),
    );
  }
}
