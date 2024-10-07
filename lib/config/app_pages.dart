import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
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
import 'app_route.dart';

class AppPages {
  static var initial = Routes.splashScreenPage;
  static final routes = [
    GetPage(
      name: Routes.splashScreenPage,
      page: () => SplashScreenPage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.referPage,
      page: () => ReferPage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashScreen(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.loginPage,
      page: () => LoginPage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.registrationPageNew,
      page: () => RegistrationPageNew(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.languageIntro,
      page: () => LanguageIntro(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.taskListPage,
      page: () => TaskListPage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.newSpin,
      page: () => NewSpin(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.dashboardPage,
      page: () => DashboardPage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.languageIntro,
      page: () => LanguageIntro(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.homePage,
      page: () => HomePage(),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.homePage1,
      page: () => HomePage1(referralCode: '',),
      // binding: MainBinding(),
    ),
    GetPage(
      name: Routes.offerDetailsPage,
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
