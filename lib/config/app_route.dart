// import 'package:get/get.dart';
// import 'package:offersapp/pages/HomePage.dart';
//
// import '../api/model/OffersData.dart';
// import '../pages/LoginPage.dart';
// import '../pages/dashboard_page.dart';
// import '../pages/language_Screen.dart';
// import '../pages/new_spin.dart';
// import '../pages/offer_details_page.dart';
// import '../pages/refer_page.dart';
// import '../pages/registration_new.dart';
// import '../pages/splash_screen.dart';
// import '../pages/splashscreen_page.dart';
// import '../pages/task_page.dart';
//
// class Routes {
//   static const String splashScreenPage = '/SplashScreenPage';
//   static const String referPage = '/ReferPage';
//   static const String splashScreen = '/SplashScreen';
//   static const String taskListPage = '/TaskListPage';
//   static const String loginPage = '/LoginPage';
//   static const String registrationPageNew = '/RegistrationPageNew';
//   static const String languageIntro = '/LanguageIntro';
//   static const String newSpin = '/NewSpin';
//   static const String dashboardPage = '/DashboardPage';
//   static const String offerDetailsPage = '/OfferDetailsPage';
//   static const String homePage = '/HomePage';
//   static const String homePage1 = '/HomePage1';
//
//   static final List<GetPage> pages = [
//     GetPage(name: splashScreenPage, page: () => SplashScreenPage()),
//     GetPage(name: referPage, page: () => ReferPage()),
//     GetPage(name: splashScreen, page: () => SplashScreen()),
//     GetPage(name: taskListPage, page: () => TaskListPage()),
//     GetPage(name: loginPage, page: () => LoginPage()),
//     GetPage(name: registrationPageNew, page: () => RegistrationPageNew()),
//     GetPage(name: languageIntro, page: () => LanguageIntro()),
//     GetPage(name: newSpin, page: () => NewSpin()),
//     GetPage(name: dashboardPage, page: () => DashboardPage()),
//     GetPage(name: homePage, page: () => HomePage()),
//     GetPage(name: homePage1, page: () => HomePage1(referralCode: '')),
//     GetPage(name: offerDetailsPage, page: () => OfferDetailsPage(data: OffersData())),
//   ];
// }

import 'package:get/get.dart';
import '../api/model/OffersData.dart';
import '../pages/HomePage.dart';
import '../pages/LoginPage.dart';
import '../pages/dashboard_page.dart';
import '../pages/language_Screen.dart';
import '../pages/new_spin.dart';
import '../pages/offer_details_page.dart';
import '../pages/refer_page.dart';
import '../pages/registration_new.dart';
import '../pages/splash_screen.dart';
import '../pages/splashscreen_page.dart';
import '../pages/task_page.dart';

class Routes {
  static const String splashScreenPage = '/SplashScreenPage';
  static const String referPage = '/ReferPage';
  static const String splashScreen = '/SplashScreen';
  static const String taskListPage = '/TaskListPage';
  static const String loginPage = '/LoginPage';
  static const String registrationPageNew = '/RegistrationPageNew';
  static const String languageIntro = '/LanguageIntro';
  static const String newSpin = '/NewSpin';
  static const String dashboardPage = '/DashboardPage';
  static const String offerDetailsPage = '/OfferDetailsPage';
  static const String homePage = '/HomePage';
  static const String homePage1 = '/HomePage1';

  static final List<GetPage> pages = [
    GetPage(name: splashScreenPage, page: () => SplashScreenPage()),
    GetPage(name: referPage, page: () => ReferPage()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: taskListPage, page: () => TaskListPage()),
    GetPage(name: loginPage, page: () => LoginPage()),
    GetPage(name: registrationPageNew, page: () => RegistrationPageNew()),
    GetPage(name: languageIntro, page: () => LanguageIntro()),
    GetPage(name: newSpin, page: () => NewSpin()),
    GetPage(name: dashboardPage, page: () => DashboardPage()),
    GetPage(name: homePage, page: () => HomePage()),
    GetPage(name: homePage1, page: () => HomePage1(referralCode: '')),
    GetPage(
      name: offerDetailsPage,
      page: () {
        // Extract the parameters passed through deep linking
        final params = Get.parameters;
        final offerId = params['offer_id']; // Expecting 'offer_id' as a parameter

        // Fetch or create OffersData using the offerId
        OffersData? offersData;
        if (offerId != null) {
          // Fetch or create your OffersData instance based on the offerId
          offersData = OffersData(offerId: offerId); // Adjust as necessary
        }

        return OfferDetailsPage(data: offersData ?? OffersData());
      },
    ),
  ];
}
