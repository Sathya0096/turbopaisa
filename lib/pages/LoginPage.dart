import 'dart:collection';
import 'dart:convert';

import 'package:advertising_id/advertising_id.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:offersapp/api/api_services/login_service.dart';
import 'package:offersapp/api/model/RegistrationResponse.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/registration_new.dart';
import 'package:offersapp/pages/registration_page.dart';
import 'package:offersapp/pages/splashscreen_page.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'HomePage.dart';

class LoginPage extends ConsumerStatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String _email = "";
  String _password = "";
  String _name = "";

  String? _advertisingId = '';
  bool? _isLimitAdTrackingEnabled;
  String _udid = 'Unknown';
  String? _ipAddress;

  var loginProvider = ChangeNotifierProvider((ref) => LoginProvider());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadIpAddress();
    requestNotificationPermissions();
    _getReferralCode();
  }

// todo this replace 3
  String? referral;

  Future<String?> getUtmSource(String fp) async {
    String url =
        'https://app.turbopaisa.com/services/device/getDeviceDetails?device_fingerprint=$fp';

    // const headers = {
    //   'Cookie': 'ci_session=hj3immi3u0pth1p93fuujkta3158bt0a',
    // };

    final response = await http.post(
      Uri.parse(url),
      //headers: headers
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['response'] == true && responseData['device'] != null) {
        return responseData['device']['utm_source'];
      } else {
        print('Unexpected response format or response false');
      }
    } else {
      print('Failed to load device details: ${response.statusCode}');
    }
    return null;
  }

  Future<void> _getReferralCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? datareferral = prefs.getString('referral');
    if (datareferral != null) {
      referral = await getUtmSource(datareferral!);
    }
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String? advertisingId;
    bool? isLimitAdTrackingEnabled;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      advertisingId = await AdvertisingId.id(true);
    } on PlatformException {
      advertisingId = 'Failed to get platform version.';
    }

    try {
      isLimitAdTrackingEnabled = await AdvertisingId.isLimitAdTrackingEnabled;
    } on PlatformException {
      isLimitAdTrackingEnabled = false;
    }

    //===== To get device UDID
    String udid;
    try {
      udid = await FlutterUdid.udid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
    //========
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    debugPrint(advertisingId);

    setState(() {
      _udid = udid;
      _advertisingId = advertisingId;
      _isLimitAdTrackingEnabled = isLimitAdTrackingEnabled;
    });
  }

  loadIpAddress() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data.toString());
      print(data['ip']);
      setState(() {
        _ipAddress = data['ip'];
      });
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      print(exception.message);
    }
  }

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void _onLoginItem(int index) async {
    await analytics.logEvent(
        name: 'user_login',
        parameters: {'user_login': index, 'page_names': 'LoginPage'});
    // analytics.logevent(
    //    Name: ‘add_to_cart’,
    //    Parameters: <String, dynamic>{
    //  ‘Product_id:’ ‘p123’,
    //  ‘Product_name’: ‘t-shirts’,
    //  ‘Products_category’: ‘cloths’,
    //  },
    //  );
  }

  // analytics.logevent(
  // Name: ‘sign_up’,
  // Parameters: <String, dynamic>{
  // ‘sign_up’: ‘google’,
  // },
  // );
  int index = 1;

  @override
  Widget build(BuildContext context) {
    var commonSpace = 16.h;
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
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                }),
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
                  padding: EdgeInsets.symmetric(horizontal: 62.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.max,
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
                                  AppLocale.loginToContinue.getString(context),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    // fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.59,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.w,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 51.sp,
                      ),
                      if (referral != null) ...[
                        // Text('Your from $referral'),
                        SizedBox(
                          height: 10.sp,
                        ),
                      ],
                      Text(
                        AppLocale.mobileNumber.getString(context),
                        style: h1textStyle,
                      ),
                      TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          NoLeadingDigitsFormatter()
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText:
                              AppLocale.typeYourMobileNumber.getString(context),
                          hintStyle: textStyle.copyWith(
                            color: const Color(0xFF8C8C8C),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Icon(
                              Icons.person,
                              size: 20.w,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                        ),
                        style: textStyle.copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                      ),

                      // SizedBox(
                      //   height: 16.h,
                      // ),
                      //
                      // Text(
                      //   'Password',
                      //   style: h1textStyle,
                      // ),
                      // TextField(
                      //     obscureText: true,
                      //     decoration: InputDecoration(
                      //       hintText: "Type your Password",
                      //       hintStyle: textStyle.copyWith(
                      //         color: Color(0xFF8C8C8C),
                      //       ),
                      //       prefixIcon: Padding(
                      //         padding: EdgeInsets.only(right: 20.w),
                      //         child: Icon(
                      //           Icons.lock,
                      //           size: 20.w,
                      //         ),
                      //       ),
                      //       prefixIconConstraints:
                      //           BoxConstraints(minWidth: 30.w),
                      //     ),
                      //     style: textStyle.copyWith(
                      //       color: Colors.black,
                      //     ),
                      //     onChanged: (value) {
                      //       _password = value;
                      //     }),

                      // SizedBox(
                      //   height: 10,
                      // ),

                      const SizedBox(
                        height: 34,
                      ),

                      InkWell(
                        onTap: () async {
                          submitData();
                          _onLoginItem(index);
                          await logLoginEvent();
                        },
                        child: Container(
                          width: 250.w,
                          height: 40.h,
                          // padding: EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFED3E55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.67),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                AppLocale.login.getString(context),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  // fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.19,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.pushReplacement(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     const RegistrationPageNew()));
                      //         // navigateToNext(context, LoginPage());
                      //       },
                      //       child: Padding(
                      //         padding: EdgeInsets.symmetric(vertical: 16.h),
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               'Don\'t have an account? ',
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: 10.sp,
                      //                 fontFamily: 'Poppins',
                      //                 fontWeight: FontWeight.w600,
                      //                 height: 1.66,
                      //               ),
                      //             ),
                      //             Text(
                      //               'Register',
                      //               style: TextStyle(
                      //                 color: AppColors.accentColor,
                      //                 fontSize: 10.sp,
                      //                 fontFamily: 'Poppins',
                      //                 fontWeight: FontWeight.w600,
                      //                 height: 1.66,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationPageNew()));
                      //     //     // navigateToNext(context, RegistrationPageNew());
                      //     //   },
                      //     //   child: Padding(
                      //     //     padding: EdgeInsets.symmetric(vertical: 16.h),
                      //     //     child: Text(
                      //     //       'Register Now',
                      //     //       style: TextStyle(
                      //     //         color: Colors.black,
                      //     //         fontSize: 10.sp,
                      //     //         fontFamily: 'Poppins',
                      //     //         fontWeight: FontWeight.w600,
                      //     //         height: 1.66,
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     sendForgotPassword();
                      //     //   },
                      //     //   child: Padding(
                      //     //     padding: EdgeInsets.symmetric(vertical: 16.h),
                      //     //     child: Text(
                      //     //       'Forgot Password?',
                      //     //       style: TextStyle(
                      //     //         color: Colors.black,
                      //     //         fontSize: 10.sp,
                      //     //         // fontFamily: 'Poppins',
                      //     //         fontWeight: FontWeight.w600,
                      //     //         height: 1.66,
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.w, top: 40.w),
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
                        padding: EdgeInsets.only(top: 16.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            "assets/images/coin_two.png",
                            //width: 80,
                          ),
                        ),
                      )
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 30),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         "assets/images/coin.png",
                      //         // width: 80,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Text(""),
                      //     SizedBox(
                      //       width: 100,
                      //     ),
                      //     Image.asset(
                      //       "assets/images/coin_two.png",
                      //       //width: 80,
                      //     ),
                      //   ],
                      // ),

                      // SizedBox(
                      //   height: 20,
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 110,
                      //     ),
                      //     Text(
                      //       "or",
                      //       style:
                      //           TextStyle(color: Colors.black.withOpacity(0.1)),
                      //     ),
                      //     SizedBox(
                      //       width: 2,
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         // navigateToNext(context, RegistrationPage());
                      //         navigateToNext(context, RegistrationPageNew());
                      //       },
                      //       child: Text(
                      //         "Sign up",
                      //         style: TextStyle(fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 85,
                      //     ),
                      //     Image.asset(
                      //       "assets/images/coin_two.png",
                      //       //width: 80,
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // buildSocialButtons(context),

                      // Image.asset(
                      //   "assets/images/rectangle .png",
                      //   //width: 80,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // SizedBox(
      //   height: 20,
      // ),
      // Center(
      //   child: Text(
      //     "Login",
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      //   ),
      // ),
      // SizedBox(
      //   height: 30,
      // ),
      // Image.asset(
      //   "assets/images/app_logo.jpeg",
      //   width: 80,
      // ),
      // SizedBox(
      //   height: 30,
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: TextField(
      //     onChanged: (value) {
      //       _email = value;
      //     },
      //     decoration: InputDecoration(hintText: "Enter Email"),
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: TextField(
      //     onChanged: (value) {
      //       _password = value;
      //     },
      //     obscureText: true,
      //     decoration: InputDecoration(hintText: "Enter Password"),
      //   ),
      // ),
      // SizedBox(
      //   height: 20,
      // ),
      // InkWell(
      //   onTap: () {
      //     submitData();
      //   },
      //   child: Container(
      //     width: 200,
      //     padding: EdgeInsets.all(10),
      //     decoration: BoxDecoration(
      //       color: Colors.blue,
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     child: Center(
      //       child: Text(
      //         "Sign In",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Padding buildSocialButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              navigateToNext(context, const SplashScreenPage());
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Image.asset(
                'assets/images/gmail_logo.png',
                fit: BoxFit.cover,
                width: 40,
                //height: 40,
              ),
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.8),
            child: Image.asset(
              'assets/images/google_logo.png',
              fit: BoxFit.cover,
              width: 40,
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.8),
            child: Image.asset(
              'assets/images/facebook_logo.png',
              fit: BoxFit.cover,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataReferral = prefs.getString('referral');
    // try {
    if (_advertisingId == null) {
      showSnackBar(context, "Advertise Id is missing.");
      return;
    }
    if (_email.trim().isEmpty) {
      showSnackBar(
          context, AppLocale.mobileNumberCannotBeBlank.getString(context));
      return;
    }
    if (_email.length < 10) {
      return showSnackBar(
          context, AppLocale.enter10DigitMobileNo.getString(context));
    }
    // if (_password.trim().isEmpty) {
    //   showSnackBar(context, "Password cannot be blank.");
    //   return;
    // }
    showLoaderDialog(context);
    Map<String, String> body = HashMap();
    body.putIfAbsent("mobileNumber", () => _email);
    body.putIfAbsent("device_fingerprint", () => dataReferral ?? "");
    body.putIfAbsent("device_id", () => _udid);
    body.putIfAbsent("login_token", () => "");
    body.putIfAbsent("ipaddress", () => _ipAddress ?? "");
    body.putIfAbsent("gaid", () => _advertisingId ?? "");
    print('device_id september: ${_udid}');
    print(body);
    var res = await ref.read(loginProvider).login(
          body: body,
          context: context,
          ref: ref,
        );
    // print(data.userId);
    // print(data.status);
    // print('status');

    // } catch (e) {
    //
    //   showSnackBar(context, "Invalid Login Details.");
    //   Navigator.pop(context);
    // }
  }

  Future<void> sendForgotPassword() async {
    try {
      if (_email.trim().isEmpty) {
        showSnackBar(context, "Username/Email cannot be blank.");
        return;
      }

      showLoaderDialog(context);
      final client = await RestClient.getRestClient();
      Map<String, String> body = HashMap();
      body.putIfAbsent("email", () => _email);

      RegistrationResponse data = await client.forgotPassword(body);
      if (data.status == 200) {
        showSnackBar(
          context,
          data.message ??
              AppLocale.successfullySentToYourRegistered.getString(context),
        );
      } else {
        showSnackBar(context, data.message ?? "Failed");
      }
      Navigator.pop(context);
    } catch (e) {
      print(e);
      showSnackBar(context, "Failed to reset password.");
      Navigator.pop(context);
    }
  }
}

DateTime? loginTime;

Future<void> logLoginEvent() async {
  loginTime = DateTime.now();
  await LoginPage.analytics.logEvent(
    name: 'login',
    parameters: {'name': 'Phone_number'},
  );
}

class NoLeadingDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow values that do not start with 0-5
    if (newValue.text.isEmpty || !RegExp(r'^[0-5]').hasMatch(newValue.text)) {
      return newValue;
    }

    // Return the old value if the new value starts with an invalid digit
    return oldValue;
  }
}
