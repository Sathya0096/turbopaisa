import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/utils/app_colors.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  //  var text = '''
  // Terms and Conditions
  //
  // 1.	Acceptance of Terms: By downloading, installing, or using our mobile app, you agree to comply with and be bound by these Terms and Conditions.
  //
  // 2.	Use of the App: You may use the app for its intended purpose, in accordance with these terms and all applicable laws and regulations.
  //
  // 3.	User Accounts: If the app requires user accounts, you agree to provide accurate and complete information during registration and to keep your account credentials secure.
  //
  // 4.	Content: You are responsible for any content you submit, post, or share through the app. You must not upload or distribute content that violates intellectual property rights, is illegal, or harmful.
  //
  // 5.	Privacy: Our Privacy Policy outlines how we collect, use, and protect your personal information. By using the app, you consent to the practices described in the Privacy Policy.
  //
  // 6.	Intellectual Property: The app and its content are protected by intellectual property laws. You may not reproduce, modify, distribute, or create derivative works without our consent.
  //
  // 7.	Third-Party Links: The app may contain links to third-party websites or services. We are not responsible for the content or practices of those third parties.
  //
  // 8.	Termination: We reserve the right to suspend or terminate your access to the app for violations of these terms or any other reason.
  //
  // 9.	Disclaimer of Warranties: The app is provided “as is” without warranties of any kind, and we do not guarantee its accuracy, reliability, or availability.
  //
  // 10.	Limitation of Liability: We are not liable for any damages arising from the use of the app. Your use of the app is at your own risk.
  //
  // 11.	Changes to Terms: We may update these terms at any time. Continued use of the app after changes constitutes your acceptance of the updated terms.
  //
  // 12.	Governing Law: These terms are governed by the laws of [Jurisdiction]. Any disputes shall be resolved in the courts of [Jurisdiction].
  //  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.whiteColor,
          ),
        ),
        title: Text(
          AppLocale.termsAndConditions.getString(context),
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child:
              Text(AppLocale.termsAndConditionsDescription.getString(context)),
        ),
      ),
    );
  }
}
