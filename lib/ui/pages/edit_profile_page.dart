import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/model/user_model.dart';
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/error_screen.dart';

import '../../common/custom_text_form_field.dart';
import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';
import '../../utils/string.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetUserInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Edit profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return _BodyView(user: state.user);
            } else if (state is ProfileUpdated) {
              return _BodyView(user: state.updatedUser);
            } else if (state is ProfileError) {
              return ErrorScreen(
                title: state.message,
                imagePath: kSorryImage,
                errorText: state.message,
                buttonText: 'Ok',
                onBtnClick: () {
                  Navigator.pop(context);
                },
              );
            }
            return ErrorScreen(
              title: 'Something went wrong',
              imagePath: kSorryImage,
              errorText:
                  'An unexpected error has occurred, and we’re working to resolve it promptly.',
              buttonText: 'Ok',
              onBtnClick: () {
                Navigator.pop(context);
              },
            );
          },
        ));
  }
}

class _BodyView extends StatelessWidget {
  final User user;

  const _BodyView({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleContent(),
                  SizedBox(
                    height: 20,
                  ),
                  ProfileForm(
                    user: user,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TitleContent extends StatelessWidget {
  const TitleContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Profile Here',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          height: 20,
        ),
        Text('Please enter the new profile detail')
      ],
    );
  }
}

class ProfileForm extends StatelessWidget {
  final User? user;

  const ProfileForm({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final firstNameController =
        TextEditingController(text: user?.firstName ?? kFirstNameHint);
    final lastNameController =
        TextEditingController(text: user?.lastName ?? kLastNameHint);
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: firstNameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return kFirstNameErrorText;
                  }
                  return null;
                },
                hintText: kFirstNameHint,
                hintTextColor: kHintTextColor,
                fillColor: kTextFieldContainer,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: CustomTextFormField(
                keyboardType: TextInputType.text,
                controller: lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return kLastNameErrorText;
                  }
                  return null;
                },
                hintText: kLastNameHint,
                hintTextColor: kHintTextColor,
                fillColor: kTextFieldContainer,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              ),
            ),
          ],
        ),
        SizedBox(height: kMarginMedium1x),
        CustomTextFormField(
          suffixIcon: Image.asset(kEmailIcon),
          readOnly: true,
          hintText: user?.email ?? '@',
          iconColor: kIconColorGrey,
          fillColor: kTextFieldContainer,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixPadding: EdgeInsets.only(right: 12),
        ),
        SizedBox(height: kMarginMedium1x),
        CustomTextFormField(
          suffixIcon: Icon(CupertinoIcons.lock),
          readOnly: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          iconColor: kIconColorGrey,
          suffixPadding: EdgeInsets.only(right: 12),
          hintText: '•',
          fillColor: kTextFieldContainer,
          hintTextColor: kHintTextColor,
        ),
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: Size(screenWidth / 1.2, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<ProfileBloc>().add(EditProfileEvent(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                  ));
            },
            child: Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
