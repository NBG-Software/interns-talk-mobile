import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/common/custom_text_form_field.dart';
import 'package:interns_talk_mobile/common/validators.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/login_page.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:interns_talk_mobile/utils/dimens.dart';
import 'package:interns_talk_mobile/utils/images.dart';
import 'package:interns_talk_mobile/utils/string.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _BodyView();
      }, listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }),
    );
  }
}

class _BodyView extends StatefulWidget {
  const _BodyView();

  @override
  State<_BodyView> createState() => _BodyViewState();
}

class _BodyViewState extends State<_BodyView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _summitForm() {
    context.read<AuthBloc>().add(AuthForgotPasswordEvent(
      email: _emailController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
           horizontal: kMarginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    suffixIcon: Image.asset(kEmailIcon),
                    iconColor: kIconColorGrey,
                    keyboardType: TextInputType.emailAddress,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    hintText: kEmailHintText,
                    validator: Validators.emailValidator,
                    fillColor: kTextFieldContainer,
                    hintTextColor: kHintTextColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    suffixPadding: EdgeInsets.only(right: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
            ),
            FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary),
                  minimumSize:
                  WidgetStatePropertyAll(Size(double.infinity, 52)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _summitForm();
                  }
                },
                child: Text('Send Email')),
          ],
        ),
      ),
    );
  }
}
