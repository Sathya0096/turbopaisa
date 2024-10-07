// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
//
// /// [DynamicLinkService]
// class DynamicLinkService {
//   static final DynamicLinkService _singleton = DynamicLinkService._internal();
//   DynamicLinkService._internal();
//   static DynamicLinkService get instance => _singleton;
//
//   // Create new dynamic link
//   void createDynamicLink() async {
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse("https://app.turbopaisa.com/services/device?referral=mobile_app&utm_source=sharing&utm_medium=sms&utm_campaign=mobile_sharing"),
//       uriPrefix: "https://imchampagnepapi.page.link",
//       androidParameters: const AndroidParameters(packageName: "com.sarj33t.flutter_deeplink_demo"),
//       // iosParameters: const IOSParameters(
//       //     bundleId: "com.sarj33t.flutterDeeplinkDemo",
//       //     appStoreId: "123456789"
//       // ),
//     );
//     final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
//     debugPrint("${dynamicLink.shortUrl}");
//   }
// }
//
// // import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// // import 'package:flutter/material.dart';
// //
// // import 'HomePage.dart';
// //
// //
// // class DynaNew extends StatefulWidget {
// //   @override
// //   _DynaNewState createState() => _DynaNewState();
// // }
// //
// // class _DynaNewState extends State<DynaNew> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _handleDynamicLinks();
// //   }
// //
// //   void _handleDynamicLinks() async {
// //     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
// //     if (initialLink?.link != null) {
// //       _handleLink(initialLink!.link);
// //     }
// //
// //     FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
// //       _handleLink(dynamicLinkData.link);
// //     }).onError((error) {
// //       debugPrint('Error in onLink: $error');
// //     });
// //   }
// //
// //   void _handleLink(Uri uri) {
// //     // Parse the link and navigate to the appropriate page
// //     if (uri.queryParameters['referral'] != null) {
// //       final referral = uri.queryParameters['referral'];
// //       debugPrint('Referral code: $referral');
// //
// //       // Navigate to a specific page based on the referral or other parameters
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => OfferPage(referralCode: referral!)),
// //       );
// //     } else {
// //       // Navigate to the home page
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => HomePage(referralCode: '',)),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(title: Text('Dynamic Links Example')),
// //         body: Center(child: Text('Home Page')),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class OfferPage extends StatelessWidget {
// //   final String referralCode;
// //
// //   OfferPage({required this.referralCode});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Offer Page')),
// //       body: Center(
// //         child: Text('Offer Page for referral code: $referralCode'),
// //       ),
// //     );
// //   }
// // }
// //
