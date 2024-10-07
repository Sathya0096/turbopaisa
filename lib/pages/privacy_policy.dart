import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/utils/app_colors.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
//   var text = '''*Advertising*
//
// 1. *Third-Party Advertisers:* We may partner with third-party advertising networks and companies to display advertisements in our app.
//
// 2. *Advertisement Delivery:* These third-party advertisers may use cookies, web beacons, and similar technologies to collect information about your interactions with the advertisements displayed, such as your device type, IP address, and app usage.
//
// 3. *Personalized Ads:* Some advertisements may be tailored to your interests and preferences based on your app usage and other online activities. These personalized ads may be delivered to you by analyzing your behavior across different apps and websites.
//
// 4. *Opt-Out:* You have the option to opt out of receiving personalized advertisements. Please note that opting out does not mean you will stop seeing ads altogether, but rather that the ads you see may be less relevant to your interests.
//
// 5. *Data Sharing:* We do not directly share your personal information with advertisers. However, advertisers may collect information directly from you or through third-party services when you interact with their advertisements.
//
// 6. *Links to Third-Party Sites:* Our app may contain links to third-party websites or apps. We are not responsible for the privacy practices of those websites or apps. We recommend reviewing their respective privacy policies.
//
// 7. *Children's Privacy:* Our app does not knowingly target children under the age of [insert age]. We do not knowingly collect personal information from children under [insert age]. If you believe we have inadvertently collected such information, please contact us immediately.
//
// 8. *Updates:* This Advertising section may be updated from time to time as our advertising practices evolve. We encourage you to review this section periodically. ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(Icons.arrow_back,color: AppColors.whiteColor,),),
        title: Text(AppLocale.privacyPolicy.getString(context),style: TextStyle(color: AppColors.whiteColor),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(AppLocale.privacyPolicyDescription.getString(context)),
        ),
      ),
    );
  }
}
