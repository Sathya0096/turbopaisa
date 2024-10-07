// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../utils/app_colors.dart';
//
// class UpdateScreen extends StatefulWidget {
//   const UpdateScreen({super.key});
//
//   @override
//   State<UpdateScreen> createState() => _UpdateScreenState();
// }
//
// const double coinHeight = 60.0;
// const double coinWidth = 60.0;
// const double columnCoinHeight = 70.0;
// const double columnCoinWidth = 70.0;
// const double cashHeight = 140.0;
// const double cashWidth = 140.0;
// const String coinAssetPath = 'assets/images/coin.png';
// const String cashAssetPath = 'assets/images/cash.png';
//
// class _UpdateScreenState extends State<UpdateScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () => Get.back(),
//             icon: const Icon(Icons.close, color: Colors.grey, size: 30),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 120.h,
//               width: 120.w,
//               child: Image.asset('assets/images/turbopaisa_logo_two.png'),
//             ),
//             const SizedBox(height: 25),
//             Text(
//               'Update your application to the latest version ',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.w600,
//                 height: 1.38,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'A brand new version is available! Explore all the exciting new features and TP points. Update Now!',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 12.sp,
//                 height: 1.38,
//               ),
//             ),
//             const SizedBox(height: 40),
//             InkWell(
//               onTap: () async {
//                 const url =
//                     'https://play.google.com/store/apps/details?id=com.tejkun.turbopaisa&hl';
//                 if (await canLaunch(url)) {
//                   await launch(url);
//                 } else {
//                   throw 'Could not launch $url';
//                 }
//               },
//               child: Container(
//                 width: 250.w,
//                 height: 40.h,
//                 decoration: ShapeDecoration(
//                   color: const Color(0xFFED3E55),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6.67),
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Update now',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w600,
//                       height: 1.38,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: coinHeight.h,
//                   width: coinWidth.w,
//                   child: Image.asset(coinAssetPath),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: columnCoinHeight.h,
//                       width: columnCoinWidth.w,
//                       child: Image.asset(coinAssetPath),
//                     ),
//                     SizedBox(
//                       height: cashHeight.h,
//                       width: cashWidth.w,
//                       child: Image.asset(cashAssetPath),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: columnCoinHeight.h,
//                   width: columnCoinWidth.w,
//                   child: Image.asset(coinAssetPath),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
