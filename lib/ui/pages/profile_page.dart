import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interns_talk_mobile/common/language_constants.dart';
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
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logging out...")),
          );
        } else if (state is AuthLoggedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            key: ValueKey('profile_button_back'),
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            key: ValueKey('profile_text_title'),
            translation(context).profileTitle,
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
            title: Text(translation(context).confirmUpload),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(selectedImage,
                    width: 180, height: 180, fit: BoxFit.cover),
                SizedBox(height: 12),
                Text(translation(context).uploadDescription)
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(translation(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(translation(context).uploadBtnText,
                    style: TextStyle(color: Colors.blue)),
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
                  Text(translation(context).uploadBtnText),
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
          key: ValueKey('profile_button_editProfile'),
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditProfilePage()));
            context.read<ProfileBloc>().add(GetUserInfoEvent());
          },
          leading: Icon(CupertinoIcons.person_circle),
          title: Text(translation(context).editProfile),
          trailing: Icon(CupertinoIcons.forward),
        ),
        ListTile(
          key: ValueKey('profile_button_goToSettings'),
          onTap: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingPage()));
            context.read<ProfileBloc>().add(GetUserInfoEvent());
          },
          leading: Icon(Icons.settings_outlined),
          title: Text(translation(context).settingTitle),
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
        key: ValueKey('profile_button_logOut'),
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
                  title: Text(translation(context).loggingOut),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text(translation(context).logOutConfirm),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      key: ValueKey('profile_dialogButton_cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(translation(context).cancel),
                    ),
                    TextButton(
                      key: ValueKey('profile_dialogButton_confirmLogOut'),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        translation(context).logoutButton,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Text(translation(context).logoutButton),
      ),
    );
  }
}
