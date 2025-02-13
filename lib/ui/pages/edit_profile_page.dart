import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';

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
    context.read<AuthBloc>().add(AuthGetUserInfoEvent());
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
      body: _BodyView(),
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
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleContent(),
                  SizedBox(
                    height: 20,
                  ),
                  ProfileForm(),
                ],
              ),
              Spacer(),
              ConfirmButton(),
              SizedBox(height: 64)
            ],
          ),
        ),
      ),
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
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthUserLoaded) {
          final user = state.user;

          final firstNameController =
              TextEditingController(text: user.firstName);
          final lastNameController = TextEditingController(text: user.lastName);

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
                suffixIconPath: kEmailIcon,
                readOnly: true,
                hintText: user.email ?? 'yourmail@gmail.com',
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
                suffixIconPath: kLockIcon,
                readOnly: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                iconColor: kIconColorGrey,
                suffixPadding: EdgeInsets.only(right: 12),
                hintText: '•',
                fillColor: kTextFieldContainer,
                hintTextColor: kHintTextColor,
              ),
            ],
          );
        } else if (state is AuthError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return Container();
      },
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: Size(screenWidth / 1.2, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {},
        child: Text('Confirm'),
      ),
    );
  }
}
