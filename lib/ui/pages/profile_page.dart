import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/edit_profile_page.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/ui/pages/setting_page.dart';
import 'package:interns_talk_mobile/utils/images.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetUserInfoEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfileBloc>().add(GetUserInfoEvent());
  }

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

class ProfileDataView extends StatefulWidget {
  const ProfileDataView({super.key});

  @override
  State<ProfileDataView> createState() => _ProfileDataViewState();
}

class _ProfileDataViewState extends State<ProfileDataView> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);

      // Show confirmation dialog
      bool? confirmUpload = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Upload'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(selectedImage, width: 180, height: 180, fit: BoxFit.cover),
                SizedBox(height: 12),
                Text("Do you want to upload this image?")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Upload', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );

      // If user confirms, update state and upload
      if (confirmUpload == true) {
        setState(() {
          _imageFile = selectedImage;
        });

        context.read<ProfileBloc>().add(UploadProfilePictureEvent(_imageFile!));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile picture updated!")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String? imageUrl;
        if (state is ProfileLoaded) {
          imageUrl = state.user.profilePicture;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      width: 148,
                      height: 148,
                      fit: BoxFit.cover,
                    )
                  : imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 148,
                          height: 148,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(kUserPlaceHolderImage,
                                width: 148, height: 148);
                          },
                        )
                      : Image.asset(
                          kUserPlaceHolderImage,
                          width: 148,
                          height: 148,
                        ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              child: Row(
                children: [
                  Image.asset(kUploadIcon),
                  SizedBox(width: 8),
                  Text('Upload'),
                ],
              ),
            ),
          ],
        );
      },
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
          onTap: () async{
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditProfilePage()));
            context.read<ProfileBloc>().add(GetUserInfoEvent());
          },
          leading: Icon(CupertinoIcons.person_circle),
          title: Text('Edit Profile'),
          trailing: Icon(CupertinoIcons.forward),
        ),
        ListTile(
          onTap: () async {
           await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingPage()));
            context.read<ProfileBloc>().add(GetUserInfoEvent());
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
