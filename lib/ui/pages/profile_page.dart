import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/edit_profile_page.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/ui/pages/setting_page.dart';
import 'package:interns_talk_mobile/utils/images.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: _BodyView(),
      ),
    );
  }
}

class _BodyView extends StatelessWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            children: [
              ProfileDataView(),
              SizedBox(
                height: 54,
              ),
              ProfileMenuItems(),
              Spacer(),
              LogOutButton(),
              SizedBox(height: 64)
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDataView extends StatelessWidget {
  const ProfileDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            kUserPlaceHolderImage,
            scale: 1.0,
            width: 148,
          ),
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
      ],
    );
  }
}

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditProfilePage()));
          },
          leading: Icon(CupertinoIcons.person_circle),
          title: Text('Edit Profile'),
          trailing: Icon(CupertinoIcons.forward),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingPage()));
          },
          leading: Icon(Icons.settings_outlined),
          title: Text('Setting'),
          trailing: Icon(CupertinoIcons.forward),
        ),
      ],
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(screenWidth / 1.2, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Logging out'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('Are you sure to log out?'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Text('Log Out'),
      ),
    );
  }
}
