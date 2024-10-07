import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:offersapp/pages/LoginPage.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/registration_new.dart';
import 'package:offersapp/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart';
import 'HomePage.dart';
import 'language_Screen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    navigateToNext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(gradient: AppColors.splashAppGradientBg),
        child: Stack(
          children: [
            // SizedBox(
            //   height: 239.h,
            // ),
            Positioned(
              top: 239.h,
              left: 128.w,
              right: 128.w,
              child: Image.asset(
                "assets/images/turbopaisa_logo_two.png",
                // fit: BoxFit.cover,
                height: 156.h,
              ),
            ),
            Positioned(
              top: 538.h,
              left: 58.w,
              child: Image.asset(
                "assets/images/coin.png",
                // width: 80,
              ),
            ),

            Positioned(
              top: 560.h,
              right: 58.w,
              child: Image.asset(
                "assets/images/coin.png",
                // width: 80,
              ),
            ),
            Positioned(
              bottom: 37.h,
              left: 94.w,
              right: 94.w,
              child: Image.asset(
                "assets/images/splash_screen_image.png",
                fit: BoxFit.cover,
                height: 177.h,
                // width: 240,
              ),
            ),
            // Spacer(),

            // SizedBox(height: 20,),
          ],
        ),
      )),
    );
  }

  // Future<void> navigateToNext() async {
  //   // user
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Future.delayed(Duration(seconds: 3), () {
  //     if (prefs.containsKey("user")) {
  //       Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(
  //           builder: (context) => DashboardPage(),
  //         ),
  //       );
  //     } else {
  //       Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(
  //           builder: (context) => LanguageIntro(),
  //         ),
  //       );
  //     }
  //   });
  // }
  Future<void> navigateToNext(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Delay navigation for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Check if user exists in preferences and navigate accordingly
    if (prefs.containsKey("user")) {
      // GoRouter.of(context).go('/DashboardPage');// Replace with the correct route for DashboardPage
      Get.toNamed('/DashboardPage');

    } else {
      // GoRouter.of(context).go('/LanguageIntro'); // Replace with the correct route for LanguageIntro
      Get.toNamed('/LanguageIntro');

    }
  }
}
