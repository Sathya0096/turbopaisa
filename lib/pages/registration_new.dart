// import 'dart:collection';
// import 'package:advertising_id/advertising_id.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_udid/flutter_udid.dart';
// import 'package:get_ip_address/get_ip_address.dart';
// import 'package:offersapp/api/api_services/registerUserService.dart';
// import 'package:offersapp/api/model/RegistrationResponse.dart';
// import 'package:offersapp/api/restclient.dart';
// import 'package:offersapp/generated/assets.dart';
// import 'package:offersapp/pages/LoginPage.dart';
// import 'package:offersapp/pages/dashboard_page.dart';
// import 'package:offersapp/pages/otp_verification_page.dart';
// import 'package:offersapp/utils.dart';
// import 'package:offersapp/utils/app_colors.dart';
//
// class RegistrationPageNew extends ConsumerStatefulWidget {
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
//
//   const RegistrationPageNew({Key? key}) : super(key: key);
//
//   @override
//   _RegistrationPageNewState createState() => _RegistrationPageNewState();
// }
//
// class _RegistrationPageNewState extends ConsumerState<RegistrationPageNew> {
//
//   var registerprovider = ChangeNotifierProvider((ref) => RegisterProvider());
//
//   String _name = "";
//   String _email = "";
//   String _mobile = "";
//   String _pincode = "";
//   String _password = "";
//   String _referralCode = "";
//
//   String? _advertisingId = '';
//   bool? _isLimitAdTrackingEnabled;
//   String _udid = 'Unknown';
//   String? _ipAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     analytics.setAnalyticsCollectionEnabled(true);
//     initPlatformState();
//     loadIpAddress();
//     requestNotificationPermissions();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   initPlatformState() async {
//     String? advertisingId;
//     bool? isLimitAdTrackingEnabled;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       advertisingId = await AdvertisingId.id(true);
//     } on PlatformException {
//       advertisingId = 'Failed to get platform version.';
//     }
//
//     try {
//       isLimitAdTrackingEnabled = await AdvertisingId.isLimitAdTrackingEnabled;
//     } on PlatformException {
//       isLimitAdTrackingEnabled = false;
//     }
//
//     //===== To get device UDID
//     String udid;
//     try {
//       udid = await FlutterUdid.udid;
//     } on PlatformException {
//       udid = 'Failed to get UDID.';
//     }
//     //========
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     debugPrint(advertisingId);
//
//     setState(() {
//       _udid = udid;
//       _advertisingId = advertisingId;
//       _isLimitAdTrackingEnabled = isLimitAdTrackingEnabled;
//     });
//   }
//   loadIpAddress() async {
//     try {
//       /// Initialize Ip Address
//       var ipAddress = IpAddress(type: RequestType.json);
//
//       /// Get the IpAddress based on requestType.
//       dynamic data = await ipAddress.getIpAddress();
//       print(data.toString());
//       print(data['ip']);
//       setState(() {
//         _ipAddress = data['ip'];
//       });
//     } on IpAddressException catch (exception) {
//       /// Handle the exception.
//       print(exception.message);
//     }
//   }
//
//   FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//
//   void _onSignupItem() async {
//     await analytics.logEvent(
//       name: 'signup',
//       parameters: <String, dynamic>{
//         'name': _name,
//         'mobile': _mobile,
//         'referral_code': _referralCode,
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var commonSpace = 16.h;
//     var textStyle = TextStyle(
//       color: Colors.black,
//       fontSize: 10.sp,
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.w500,
//       height: 1.66,
//     );
//     var h1textStyle = TextStyle(
//       color: Colors.black,
//       fontSize: 10.sp,
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.w600,
//       height: 1.66,
//     );
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           // rgba(224, 234, 255, 0.48), rgba(224, 234, 255, 0.52), rgba(224, 234, 255, 1)
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromRGBO(224, 234, 255, 0.48),
//                   Color.fromRGBO(224, 234, 255, 0.52),
//                   Color.fromRGBO(224, 234, 255, 1),
//                 ]),
//           ),
//           // padding: EdgeInsets.symmetric(horizontal: 62.sp),
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: RotatedBox(
//                   quarterTurns: 90,
//                   child: ClipPath(
//                     clipper: GreenClipperReverse(),
//                     child: Container(
//                       height: 115.h,
//                       color: Color(0xff222467),
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Padding(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
//                   child: Icon(Icons.arrow_back_rounded),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 62.sp,vertical: 35.h),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 21.h,
//                       ),
//                       Align(
//                         alignment: Alignment.topCenter,
//                         child: Image.asset(
//                           "assets/images/turbopaisa_logo_two.png",
//                           height: 69.h,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 25.h,
//                       ),
//                       Stack(
//                         children: [
//                           Align(
//                             alignment: Alignment.topCenter,
//                             child: SvgPicture.asset(
//                               Assets.svgRegisterRectangle,
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Text(
//                               'Registration',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18.sp,
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 // height: 0.97,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 30.sp,
//                       ),
//                       Text(
//                         'Username',
//                         style: h1textStyle,
//                       ),
//                       TextField(
//                         inputFormatters: [
//                           FilteringTextInputFormatter(RegExp(r'[a-z A-Z]'), allow: true),
//
//                         ],
//                         decoration: InputDecoration(
//                           hintStyle: textStyle.copyWith(
//                             color: Color(0xFF8C8C8C),
//                           ),
//
//                           hintText: "Type your name",
//                           prefixIcon: Padding(
//                             padding: EdgeInsets.only(right: 20.w),
//                             child: Icon(
//                               Icons.person,
//                               size: 20.w,
//                             ),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 30.w),
//                         ),
//                         style: textStyle.copyWith(
//                           color: Colors.black,
//                         ),
//                         onChanged: (value) {
//                           _name = value;
//                         },
//                       ),
//                       // SizedBox(
//                       //   height: commonSpace,
//                       // ),
//                       // Text(
//                       //   'Password ',
//                       //   style: h1textStyle,
//                       // ),
//                       // TextField(
//                       //   obscureText: true,
//                       //   decoration: InputDecoration(
//                       //     hintText: "Type your password",
//                       //     hintStyle: textStyle.copyWith(
//                       //       color: Color(0xFF8C8C8C),
//                       //     ),
//                       //     prefixIcon: Padding(
//                       //       padding: EdgeInsets.only(right: 20.w),
//                       //       child: Icon(
//                       //         Icons.lock,
//                       //         size: 20.w,
//                       //       ),
//                       //     ),
//                       //     prefixIconConstraints: BoxConstraints(minWidth: 30.w),
//                       //   ),
//                       //   style: textStyle.copyWith(
//                       //     color: Colors.black,
//                       //   ),
//                       //   onChanged: (value) {
//                       //     _password = value;
//                       //   },
//                       // ),
//                       SizedBox(
//                         height: commonSpace,
//                       ),
//                       Text(
//                         'Phone ',
//                         style: h1textStyle,
//                       ),
//                       TextField(
//                         keyboardType: TextInputType.phone,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                         decoration: InputDecoration(
//                           hintText: "Type your phone number",
//                           hintStyle: textStyle.copyWith(
//                             color: Color(0xFF8C8C8C),
//                           ),
//                           prefixIcon: Padding(
//                             padding: EdgeInsets.only(right: 20.w),
//                             child: Icon(
//                               Icons.phone,
//                               size: 20.w,
//                             ),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 30.w),
//                         ),
//                         style: textStyle.copyWith(
//                           color: Colors.black,
//                         ),
//                         onChanged: (value) {
//                           _mobile = value;
//                         },
//                       ),
//                       SizedBox(
//                         height: commonSpace,
//                       ),
//                       Text(
//                         'Referral Code',
//                         style: h1textStyle,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           hintText: "Referral Code (optional)",
//                           hintStyle: textStyle.copyWith(
//                             color: Color(0xFF8C8C8C),
//                           ),
//                           prefixIcon: Padding(
//                             padding: EdgeInsets.only(right: 20.w),
//                             child: Icon(
//                               Icons.group,
//                               size: 20.w,
//                             ),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 30.w),
//                         ),
//                         style: textStyle.copyWith(
//                           color: Colors.black,
//                         ),
//                         onChanged: (value) {
//                           _referralCode = value;
//                         },
//                       ),
//                       SizedBox(
//                         height: 44.sp,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           // HapticFeedback.lightImpact();
//                           submitData(context);
//                         },
//                         child: Container(
//                           width: 250.w,
//                           height: 40.h,
//                           decoration: ShapeDecoration(
//                             color: Color(0xFFED3E55),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6.67),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Sign up',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14.sp,
//                                 fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.19,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 40),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   children: [
//                       //     InkWell(
//                       //       onTap: () {
//                       //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
//                       //         // navigateToNext(context, LoginPage());
//                       //       },
//                       //       child: Padding(
//                       //         padding: EdgeInsets.symmetric(vertical: 16.h),
//                       //         child: Row(
//                       //           children: [
//                       //             Text(
//                       //               'Already have an account? ',
//                       //               style: TextStyle(
//                       //                 color: Colors.black,
//                       //                 fontSize: 10.sp,
//                       //                 fontFamily: 'Poppins',
//                       //                 fontWeight: FontWeight.w600,
//                       //                 height: 1.66,
//                       //               ),
//                       //             ),
//                       //             Text(
//                       //               'Login',
//                       //               style: TextStyle(
//                       //                 color: AppColors.accentColor,
//                       //                 fontSize: 10.sp,
//                       //                 fontFamily: 'Poppins',
//                       //                 fontWeight: FontWeight.w600,
//                       //                 height: 1.66,
//                       //               ),
//                       //             ),
//                       //           ],
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 7.w, top: 0.w),
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               "assets/images/coin.png",
//                               // width: 80,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(top: 16.h),
//                         child: Align(
//                           alignment: Alignment.bottomRight,
//                           child: Image.asset(
//                             "assets/images/coin_two.png",
//                             //width: 80,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> submitData(context) async {
//     if(_name.isEmpty){
//       return showSnackBar(context, 'Enter name');
//     }
//     if(_password.isEmpty){
//       return showSnackBar(context, 'Enter password');
//     }
//     try {
//       showLoaderDialog(context);
//
//       Map<String, String> body = HashMap();
//       body.putIfAbsent("name", () => _name);
//       body.putIfAbsent("mobile", () => _mobile);
//       body.putIfAbsent("device_id", () => _udid);
//       body.putIfAbsent("login_token", () => "");
//       body.putIfAbsent("ipaddress", () => _ipAddress ?? "");
//       body.putIfAbsent("gaid", () => _advertisingId ?? "");
//       body.putIfAbsent("referral_id", () => _referralCode);
//
//       var res = await ref.read(registerprovider).register(
//         ref: ref, context: context, body: body,
//       );
//       if (res == true) {
//         _onSignupItem();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => DashboardPage()),
//         );
//       }
//     } catch (e) {
//       print(e);
//       showSnackBar(context, "Invalid Details.");
//       Navigator.pop(context);
//     }
//     String pattern = r'^(?=.*[A-Z])(?=\S{6,}$).*$';
//     RegExp regExp = RegExp(pattern);
//     if (!regExp.hasMatch(_password)) {
//       return showSnackBar(context, 'Password must contain atleast 6 characters with one uppercase letter and without blank spaces.');
//     }
//     if(_mobile.length < 10){
//       return showSnackBar(context, 'Enter 10 digit mobile no.');
//     }
//     try {
//       showLoaderDialog(context);
//
//       Map<String, String> body = HashMap();
//       body.putIfAbsent("name", () => _name);
//       // body.putIfAbsent("email", () => _email);
//       body.putIfAbsent("mobile", () => _mobile);
//       //
//       body.putIfAbsent("device_id", () => _udid);
//       body.putIfAbsent("login_token", () => "");
//       body.putIfAbsent("ipaddress", () => _ipAddress ?? "");
//       body.putIfAbsent("gaid", () => _advertisingId ?? "");
//       //
//       // body.putIfAbsent("pincode", () => _pincode);
//       // body.putIfAbsent("password", () => _password);
//       body.putIfAbsent("referral_id", () => _referralCode);
//
//       var res = await ref.read(registerprovider).register(
//         ref: ref,context: context,body: body,
//       );
//       if(res == true){
//         print('aaa');
//       }
//
//     } catch (e) {
//       print(e);
//       showSnackBar(context, "Invalid Details.");
//       Navigator.pop(context);
//     }
//   }
//
//   DateTime? loginTime;
//
//   Future<void> logRegisterEvent() async {
//     loginTime = DateTime.now();
//     await RegistrationPageNew.analytics.logEvent(
//       name: 'register',
//       parameters: {'method': 'email'},
//     );
//   }
//
// }

import 'dart:collection';
import 'package:advertising_id/advertising_id.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/route_manager.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:offersapp/api/api_services/registerUserService.dart';
import 'package:offersapp/api/model/RegistrationResponse.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/LoginPage.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/otp_verification_page.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class RegistrationPageNew extends ConsumerStatefulWidget {
  const RegistrationPageNew({Key? key}) : super(key: key);

  @override
  _RegistrationPageNewState createState() => _RegistrationPageNewState();
}

class _RegistrationPageNewState extends ConsumerState<RegistrationPageNew> {
  var registerprovider = ChangeNotifierProvider((ref) => RegisterProvider());

  String _name = "";
  String _email = "";
  String _mobile = "";
  String _pincode = "";
  String _password = "";
  String _referralCode = "";

  String? _advertisingId = '';
  bool? _isLimitAdTrackingEnabled;
  String _udid = 'Unknown';
  String? _ipAddress;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadIpAddress();
    requestNotificationPermissions();
  }

  TextEditingController _textEditingController = TextEditingController();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void _onLoginItem(int index) async {
    await analytics.logEvent(
        name: 'user_register',
        parameters: {'user_register': index, 'page_names': 'user_register'});
    // analytics.logevent(
    //    Name: ‘add_to_cart’,
    //    Parameters: <String, dynamic>{
    //  ‘Product_id:’ ‘p123’,
    //  ‘Product_name’: ‘t-shirts’,
    //  ‘Products_category’: ‘cloths’,
    //  },
    //  );
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

  int index = 1;

  @override
  Widget build(BuildContext context) {
    var commonSpace = 16.h;
    var textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.66,
    );
    var h1textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      height: 1.66,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // rgba(224, 234, 255, 0.48), rgba(224, 234, 255, 0.52), rgba(224, 234, 255, 1)
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(224, 234, 255, 0.48),
                  Color.fromRGBO(224, 234, 255, 0.52),
                  Color.fromRGBO(224, 234, 255, 1),
                ]),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 62.sp),
          child: Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back)),
              Align(
                alignment: Alignment.bottomCenter,
                child: RotatedBox(
                  quarterTurns: 90,
                  child: ClipPath(
                    clipper: GreenClipperReverse(),
                    child: Container(
                      height: 115.h,
                      color: Color(0xff222467),
                    ),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Padding(
              //     padding:
              //         EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
              //     child: Icon(Icons.arrow_back_rounded),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 62.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 21.h,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "assets/images/turbopaisa_logo_two.png",
                        height: 69.h,
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            Assets.svgRegisterRectangle,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            AppLocale.registration.getString(context),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              // height: 0.97,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.sp,
                    ),
                    Text(
                      AppLocale.userName.getString(context),
                      style: h1textStyle,
                    ),
                    TextField(
                        controller: _textEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'[a-z A-Z]'),
                              allow: true),
                        ],
                        decoration: InputDecoration(
                          hintStyle: textStyle.copyWith(
                            color: Color(0xFF8C8C8C),
                          ),
                          hintText: AppLocale.typeYourName.getString(context),
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
                          if (value.isNotEmpty && value[0] == ' ') {
                            _textEditingController.text = value.trimLeft();
                            _textEditingController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _textEditingController.text.length),
                            );
                          } else {
                            _name = value;
                          }
                        }),
                    // SizedBox(
                    //   height: commonSpace,
                    // ),
                    // Text(
                    //   'Password ',
                    //   style: h1textStyle,
                    // ),
                    // TextField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     hintText: "Type your password",
                    //     hintStyle: textStyle.copyWith(
                    //       color: Color(0xFF8C8C8C),
                    //     ),
                    //     prefixIcon: Padding(
                    //       padding: EdgeInsets.only(right: 20.w),
                    //       child: Icon(
                    //         Icons.lock,
                    //         size: 20.w,
                    //       ),
                    //     ),
                    //     prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                    //   ),
                    //   style: textStyle.copyWith(
                    //     color: Colors.black,
                    //   ),
                    //   onChanged: (value) {
                    //     _password = value;
                    //   },
                    // ),
                    SizedBox(
                      height: commonSpace,
                    ),
                    Text(
                      AppLocale.phone.getString(context),
                      style: h1textStyle,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        NoLeadingDigitsFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText:
                            AppLocale.typeYourPhoneNumber.getString(context),
                        hintStyle: textStyle.copyWith(
                          color: Color(0xFF8C8C8C),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: Icon(
                            Icons.phone,
                            size: 20.w,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                      ),
                      style: textStyle.copyWith(
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        _mobile = value;
                      },
                    ),
                    SizedBox(
                      height: commonSpace,
                    ),
                    Text(
                      AppLocale.referralCode.getString(context),
                      style: h1textStyle,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            AppLocale.referralCodeOptional.getString(context),
                        hintStyle: textStyle.copyWith(
                          color: Color(0xFF8C8C8C),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: Icon(
                            Icons.group,
                            size: 20.w,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                      ),
                      style: textStyle.copyWith(
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        _referralCode = value;
                      },
                    ),
                    SizedBox(
                      height: 44.sp,
                    ),
                    InkWell(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        submitData(context);
                        _onLoginItem(index);
                        await signUpEvents();
                      },
                      // onTap: () async {
                      // submitData();
                      // _onLoginItem(index);
                      // await logLoginEvent();
                      //                   },
                      child: Container(
                        width: 250.w,
                        height: 40.h,
                        decoration: ShapeDecoration(
                          color: Color(0xFFED3E55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.67),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppLocale.signup.getString(context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.19,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 45),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                    //         // navigateToNext(context, LoginPage());
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 16.h),
                    //         child: Row(
                    //           children: [
                    //             Text(
                    //               'Already have an account? ',
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 10.sp,
                    //                 fontFamily: 'Poppins',
                    //                 fontWeight: FontWeight.w600,
                    //                 height: 1.66,
                    //               ),
                    //             ),
                    //             Text(
                    //               'Login',
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
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.w, top: 0.w),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataReferral = prefs.getString('referral');

    if (_name.isEmpty) {
      return showSnackBar(context, AppLocale.enterName.getString(context));
    }
    // if(_password.isEmpty){
    //   return showSnackBar(context, 'Enter password');
    // }
    // String pattern = r'^(?=.*[A-Z])(?=\S{6,}$).*$';
    // RegExp regExp = RegExp(pattern);
    // if (!regExp.hasMatch(_password)) {
    //   return showSnackBar(context, 'Password must contain atleast 6 characters with one uppercase letter and without blank spaces.');
    // }
    if (_mobile.length < 10) {
      return showSnackBar(
          context, AppLocale.enter10DigitMobileNo.getString(context));
    }
    try {
      showLoaderDialog(context);

      Map<String, String> body = HashMap();
      body.putIfAbsent("name", () => _name);
      // body.putIfAbsent("email", () => _email);
      body.putIfAbsent("mobile", () => _mobile);
      //
      body.putIfAbsent("device_id", () => _udid);
      body.putIfAbsent("login_token", () => "");
      body.putIfAbsent("ipaddress", () => _ipAddress ?? "");
      body.putIfAbsent("gaid", () => _advertisingId ?? "");
      body.putIfAbsent("device_fingerprint", () => dataReferral ?? "");
      //
      // body.putIfAbsent("pincode", () => _pincode);
      // body.putIfAbsent("password", () => _password);
      body.putIfAbsent("referral_id", () => _referralCode);

      var res = await ref.read(registerprovider).register(
            ref: ref,
            context: context,
            body: body,
          );
      if (res == true) {
        // print('dee sathya');
      }
    } catch (e) {
      print(e);
      // showSnackBar(context, AppLocale.userAlreadyExistedWithThisMobileNumber.getString(context));
      Navigator.pop(context);
    }
  }
}

DateTime? loginTime;

Future<void> signUpEvents() async {
  loginTime = DateTime.now();
  await LoginPage.analytics.logEvent(
    name: 'signup_turbo',
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
    if (newValue.text.isEmpty ||
        !RegExp(r'^[0-5]').hasMatch(newValue.text)) {
      return newValue;
    }

    // Return the old value if the new value starts with an invalid digit
    return oldValue;
  }
}