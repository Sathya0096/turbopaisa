import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/app_route.dart';
import '../generated/assets.dart';
import '../utils/app_colors.dart';
import 'HomePage.dart';
import 'dashboard_page.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _referral = '';

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      // fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.66,
    );

    var h1textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      // fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      height: 1.66,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration:
                  const BoxDecoration(gradient: AppColors.appLoginGradientBg),
            ),
            Positioned(
              bottom: -20.w,
              left: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: 90,
                child: ClipPath(
                  clipper: GreenClipperReverse(),
                  child: Container(
                    // height: 70.h,
                    height: 115.h,
                    color: const Color(0xff222467),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 31.h),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/images/turbopaisa_logo_two.png",
                          width: 108.w,
                        ),
                      ),
                      SizedBox(
                        height: 51.h,
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SvgPicture.asset(
                              Assets.svgRegisterRectangle,
                              width: 217.w,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Text(
                                  AppLocale.welcome.getString(context),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    // fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 1.06,
                                  ),
                                ),
                                Text(
                                  AppLocale.selectLoginOrSignup
                                      .getString(context),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    // fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.59,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      SizedBox(
                        height: 215,
                        child: Image.asset('assets/images/cup.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocale.pleaseLoginOrSignUp.getString(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 25),
                      InkWell(
                        onTap: () async {
                          print('WEBVIEW OPENING');
                          // _grecaptcha
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          final referral = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebViewPage()),
                          );
                          print('WEBVIEW COMPLETED');
                          setState(() {
                            _referral = referral ?? 'No referral found';
                          });
                          print('Device_FingerPrint $_referral');

                          await prefs.setString('referral', referral);
                          setState(() {});

                          print('sathya login');
                          Get.toNamed('/LoginPage');
                        },
                        child: Container(
                          height: 40,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFED3E55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.67),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              AppLocale.login.getString(context),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                // fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          print('WEBVIEW OPENING');

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          final referral = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WebViewPage()),
                          );
                          print('WEBVIEW COMPLETED');
                          setState(() {
                            _referral = referral ?? 'No referral found';
                          });
                          print('device_fingerprint $_referral');

                          await prefs.setString('referral', referral);
                          setState(() {});

                          print('sathya signup');
                          Get.toNamed('/RegistrationPageNew');
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.65),
                              border:
                                  Border.all(color: const Color(0xFFED3E55))),
                          child: Center(
                            child: Text(
                              AppLocale.signup.getString(context),
                              style: TextStyle(
                                fontSize: 12.sp,
                                // fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.w, top: 20.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/coin.png",
                              // width: 80,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            "assets/images/coin_two.png",
                            //width: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  late Timer _countdownTimer;
  int _secondsRemaining = 1;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _getReferralFromLocalStorage();
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://app.turbopaisa.com/services/device'));
  }

  void _getReferralFromLocalStorage() async {
    final String? referral = (await _controller.runJavaScriptReturningResult(
        "localStorage.getItem('referral');")) as String?;
    if (referral != null && referral.isNotEmpty) {
      print('Referral: $referral');
      final String cleanedReferral = referral.replaceAll('"', '');
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context, cleanedReferral);
      });
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6FA),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Center(
                child: SizedBox(
                  height: 215,
                  child: Image.asset('assets/images/wallet_withname.png'),
                ),
              ),
            ),
            // Expanded(
            //     flex: 2,
            //     child: Text(
            //       _secondsRemaining < 1 ? 'Loading...' : ' $_secondsRemaining',
            //       style: Theme.of(context)
            //           .textTheme
            //           .displayLarge
            //           ?.copyWith(color: Colors.purple),
            //     )),
            Expanded(flex: 1, child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
