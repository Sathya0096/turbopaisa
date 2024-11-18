import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:offersapp/pages/HomePage.dart';
import 'package:offersapp/pages/offer_details_page.dart';
import 'Config/app_route.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance = AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial link if the app was opened from a terminated state with a deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _openAppLink(initialUri);
    }

    // Listen for deep links while the app is running or in the background
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('Received deep link: $uri');
      if (uri != null) {
        _openAppLink(uri);
      } else {
        debugPrint('No URI received');
      }
    }, onError: (error) {
      debugPrint('Error receiving deep link: $error');
    });
  }
  

  // void _openAppLink(Uri uri) {
  //   print('Received URI: $uri');
  //   String path = uri.path;
  //   Map<String, String> queryParams = uri.queryParameters;
  //
  //   print('Navigating to path: $path with params: $queryParams');
  //
  //   switch (path) {
  //     case '/offerDetailsPage':
  //     // Check if offer_id is available in query parameters
  //       final offerId = queryParams['offer_id'];
  //       if (offerId != null) {
  //         // Navigate to offerDetailsPage with offerId as an argument
  //         Get.toNamed(Routes.offerDetailsPage, arguments: {'offer_id': offerId});
  //       } else {
  //         // Navigate to offerDetailsPage without an offer ID
  //         Get.toNamed(Routes.offerDetailsPage);
  //       }
  //       break;
  //     default:
  //       print('Unknown path: $path');
  //       // Fallback for unknown paths
  //       Get.toNamed(Routes.homePage); // You may change this to a more appropriate default
  //   }
  // }

  void _openAppLink(Uri uri) {
    print('Received URI: $uri');
    String path = uri.path;
    Map<String, String> queryParams = uri.queryParameters;

    print('Navigating to path: $path with params: $queryParams');

    switch (path) {
      case '/offerDetailsPage':
        final offerId = queryParams['offer_id'];
        if (offerId != null) {
          print('Navigating to offerDetailsPage with offer_id: $offerId');
          Get.toNamed(Routes.offerDetailsPage, arguments: {'offer_id': offerId});
        } else {
          print('Navigating to offerDetailsPage without offer_id');
          Get.toNamed(Routes.offerDetailsPage);
        }
        break;
      default:
        print('Unknown path: $path');
        Get.toNamed(Routes.homePage);
    }
  }


  void dispose() {
    _linkSubscription?.cancel();
  }
}


// import 'dart:async';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'Config/app_route.dart';
//
// class AppLinksDeepLink {
//   AppLinksDeepLink._privateConstructor();
//
//   static final AppLinksDeepLink _instance = AppLinksDeepLink._privateConstructor();
//
//   static AppLinksDeepLink get instance => _instance;
//
//   late AppLinks _appLinks;
//   StreamSubscription<Uri>? _linkSubscription;
//
//   Future<void> initDeepLinks() async {
//     _appLinks = AppLinks();
//
//     // Handle initial link if the app was opened from a terminated state with a deep link
//     final initialUri = await _appLinks.getInitialLink();
//     if (initialUri != null) {
//       _openAppLink(initialUri);
//     }
//
//     // Listen for deep links while the app is running or in the background
//     _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
//       debugPrint('Received deep link: $uri');
//       if (uri != null) {
//         _openAppLink(uri);
//       } else {
//         debugPrint('No URI received');
//       }
//     }, onError: (error) {
//       debugPrint('Error receiving deep link: $error');
//     });
//   }
//
//   // Handle navigation based on the deep link's path and query parameters
//   // void _openAppLink(Uri uri) {
//   //   print('Received URI: $uri');
//   //   String path = uri.path;
//   //   Map<String, String> queryParams = uri.queryParameters;
//   //
//   //   print('Navigating to path: $path with params: $queryParams');
//   //
//   //   switch (path) {
//   //     case '/offerDetailsPage':
//   //     // Extract the offer_id from query parameters
//   //       final offerId = queryParams['offer_id'];
//   //       if (offerId != null) {
//   //         Get.toNamed(Routes.offerDetailsPage, arguments: {'offer_id': offerId});
//   //       } else {
//   //         print('offer_id not found in the query parameters');
//   //       }
//   //       break;
//   //     default:
//   //       print('Unknown path: $path');
//   //       Get.toNamed(Routes.homePage); // Navigate to homepage for unknown paths
//   //   }
//   // }
//
//   // Dispose the link subscription when it's no longer needed
//
//   void _openAppLink(Uri uri) {
//     print('Received URI: $uri');
//     String path = uri.path;
//     Map<String, String> queryParams = uri.queryParameters;
//
//     print('Navigating to path: $path with params: $queryParams');
//
//     switch (path) {
//       case '/':
//         final offerId = queryParams['offer_id'];
//         if (offerId != null) {
//           print('Navigating to offerDetailsPage with offer_id: $offerId');
//           Get.toNamed(Routes.homePage1,
//               // arguments: {'offer_id': offerId}
//           );
//         } else {
//           print('offer_id not found in the query parameters');
//         }
//         break;
//       default:
//         print('Unknown path: $path');
//         Get.toNamed(Routes.homePage1); // or whichever route is appropriate
//     }
//   }
//
//   void dispose() {
//     _linkSubscription?.cancel();
//   }
// }


// todo fromm google
// import 'dart:async';
// import 'package:app_links/app_links.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// class AppLinksDeepLink extends GetxController {
//   AppLinksDeepLink._privateConstructor();
//
//   static final AppLinksDeepLink _instance = AppLinksDeepLink._privateConstructor();
//
//   static AppLinksDeepLink get instance => _instance;
//
//   late AppLinks _appLinks;
//   StreamSubscription<Uri>? _linkSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _appLinks = AppLinks();
//     initDeepLinks();
//   }
//
//   Future<void> initDeepLinks() async {
//     // Check initial link if app was in cold state (terminated)
//     final appLink = await _appLinks.getInitialLink(); // Use getInitialLink instead
//     if (appLink != null) {
//       handleRedirect(Uri.parse(appLink as String)); // Parse the string to a URI
//     }
//
//     // Handle link when app is in warm state (front or background)
//     _linkSubscription = _appLinks.uriLinkStream.listen(
//           (uriValue) {
//         print('Listening to URL updates: $uriValue');
//         handleRedirect(uriValue);
//       },
//       onError: (err) {
//         debugPrint('====>>> error : $err');
//       },
//       onDone: () {
//         _linkSubscription?.cancel();
//       },
//     );
//   }
//
//   void handleRedirect(Uri uri) {
//     print('Redirecting from URL: $uri');
//     // Add your redirection logic here based on the URI
//     // Example: Get.toNamed('/yourRoute'); // Use appropriate route
//   }
//
//   @override
//   void onClose() {
//     _linkSubscription?.cancel();
//     super.onClose();
//   }
// }
