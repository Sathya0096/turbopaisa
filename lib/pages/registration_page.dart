// import 'dart:collection';
// import 'dart:convert';
// import 'package:advertising_id/advertising_id.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_udid/flutter_udid.dart';
// import 'package:get_ip_address/get_ip_address.dart';
// import 'package:offersapp/pages/localization_language.dart';
// import 'package:offersapp/utils/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../api/model/RegistrationResponse.dart';
// import '../api/model/UserData.dart';
// import '../api/restclient.dart';
// import '../utils.dart';
// import 'dashboard_page.dart';
//
// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({Key? key}) : super(key: key);
//
//   @override
//   State<RegistrationPage> createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
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
//     initPlatformState();
//     loadIpAddress();
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
//
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "",
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Color.fromRGBO(224, 234, 255, 0.48),
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             decoration: BoxDecoration(gradient: AppColors.appLoginGradientBg),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: RotatedBox(
//               quarterTurns: 90,
//               child: ClipPath(
//                 clipper: GreenClipperReverse(),
//                 child: Container(
//                   height: 80,
//                   color: Color(0xff222467),
//                 ),
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Container(
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Image.asset(
//                       "assets/images/turbopaisa_logo_two.png",
//                       width: 80,
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Stack(children: [
//                       Image.asset(
//                         "assets/images/login_rectangle.png",
//                         width: 220,
//                       ),
//                       Positioned.fill(
//                           child: Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 AppLocale.registration.getString(context),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 20),
//                               ))),
//                     ]),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 40),
//                             child: Text(
//                               AppLocale.userName.getString(context),
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.person),
//                               hintText: AppLocale.typeYourName.getString(context),
//                             ),
//                             onChanged: (value) {
//                               _name = value;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 40),
//                             child: Text(
//                               "Password",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             )),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock),
//                               hintText: "Type your Password",
//                             ),
//                             onChanged: (value) {
//                               _password = value;
//                             },
//                             //decoration: InputDecoration(hintText: "Enter Phone number"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // SizedBox(
//                     //   height: 10,
//                     // ),
//                     // Column(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     Padding(
//                     //       padding: EdgeInsets.symmetric(horizontal: 40),
//                     //       child: Text(
//                     //         "Email",
//                     //         style: TextStyle(fontWeight: FontWeight.bold),
//                     //       ),
//                     //     ),
//                     //     Padding(
//                     //       padding: const EdgeInsets.only(left: 40, right: 40),
//                     //       child: TextField(
//                     //         decoration: InputDecoration(
//                     //           prefixIcon: Icon(Icons.mail),
//                     //           hintText: "Type your Email",
//                     //         ),
//                     //
//                     //         onChanged: (value) {
//                     //           _email = value;
//                     //         },
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 40),
//                           child: Text(
//                             AppLocale.phone.getString(context),
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.phone),
//                               hintText: AppLocale.typeYourPhoneNumber.getString(context),
//                             ),
//                             onChanged: (value) {
//                               _mobile = value;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 40),
//                           child: Text(
//                             AppLocale.referralCode.getString(context),
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.person_sharp),
//                               //contentPadding: EdgeInsets.all(50.0),
//                               hintText: AppLocale.referralCodeOptional.getString(context),
//                             ),
//                             onChanged: (value) {
//                               _referralCode = value;
//                             },
//                             // decoration:
//                             //     InputDecoration(hintText: "Referral Code (Optional)"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 34,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         submitData();
//                       },
//                       child: Container(
//                         width: 260,
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: AppColors.accentColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text(
//                               "Sign up",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 60),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             "assets/images/coin.png",
//                             // width: 80,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Text(""),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Image.asset(
//                           "assets/images/coin_two.png",
//                           //width: 80,
//                         ),
//                       ],
//                     ),
//                     // Image.asset(
//                     //   "assets/images/rectangle .png",
//                     //   //width: 80,
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> submitData() async {
//     try {
//       showLoaderDialog(context);
//       final client = await RestClient.getRestClient();
//       Map<String, String> body = HashMap();
//       body.putIfAbsent("name", () => _name);
//       body.putIfAbsent("email", () => _email);
//       body.putIfAbsent("mobile", () => _mobile);
//       //
//       body.putIfAbsent("device_id", () => _udid);
//       body.putIfAbsent("login_token", () => "");
//       body.putIfAbsent("ipaddress", () => _ipAddress ?? "");
//       body.putIfAbsent("gaid", () => _advertisingId ?? "");
//       //
//       body.putIfAbsent("pincode", () => _pincode);
//       body.putIfAbsent("password", () => _password);
//       body.putIfAbsent("referral_id", () => _referralCode);
//
//       RegistrationResponse data = await client.doRegister(body);
//       if (data.status != 200) {
//         showSnackBar(context, data.message ?? "");
//         Navigator.pop(context);
//       } else {
//         // SharedPreferences prefs = await SharedPreferences.getInstance();
//         // await prefs.setString("user", jsonEncode(data));
//         Navigator.pop(context);
//         Navigator.pop(context);
//         showSnackBar(context, data.message ?? "");
//       }
//     } catch (e) {
//       print(e);
//       showSnackBar(context, "Invalid Details.");
//       Navigator.pop(context);
//     }
//   }
// }
