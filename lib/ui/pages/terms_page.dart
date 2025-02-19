import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Terms and Conditions',style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Terms and Conditions for Interns Talk

Last Updated: 19.2.2025

Welcome to Interns Talk ("App"). By using our services, you agree to comply with the following terms and conditions. Please read them carefully.

1. Acceptance of Terms

By accessing or using the App, you agree to be bound by these Terms and Conditions ("Terms"). If you do not agree with any part of these Terms, you must discontinue using the App immediately.

2. User Eligibility

You must be at least 13 years old (or the minimum legal age in your country) to use this App. If you are under 18, you must have parental consent to use the App.

3. Account Registration

You must provide accurate and complete information when creating an account.

You are responsible for maintaining the confidentiality of your account credentials.

We reserve the right to suspend or terminate accounts found to be in violation of these Terms.

4. User Conduct

By using the App, you agree:

Not to use the App for illegal, harmful, or abusive activities.

Not to send spam, offensive, or inappropriate content.

Not to impersonate others or misrepresent your identity.

Not to attempt to hack, disrupt, or manipulate the App's services.

5. Content Ownership & Privacy

You retain ownership of any content you send or share within the App.

By using the App, you grant us a limited, non-exclusive license to use your content for service functionality.

We respect your privacy. Please refer to our Privacy Policy for details on data collection and usage.

6. Prohibited Activities

You must not:

Use the App for harassment, bullying, or spreading false information.

Share content that infringes intellectual property rights or contains malicious software.

Engage in activities that violate local, national, or international laws.

7. Termination & Suspension

We reserve the right to suspend or terminate your access to the App at our discretion if you violate these Terms.

8. Limitation of Liability

The App is provided "as is." We are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the App.

9. Modifications to the Terms

We may update these Terms from time to time. Your continued use of the App after changes are posted constitutes acceptance of the revised Terms.

10. Contact Us

If you have any questions regarding these Terms, please contact us at sankyawhtwe@nbg.com.mm.''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
