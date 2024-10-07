import 'dart:convert';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:offersapp/pages/HomePage.dart';
import 'package:offersapp/pages/HomePage.dart';
import 'package:offersapp/pages/HomePage.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/offer_details_page.dart';
import 'package:offersapp/pages/splash_screen.dart';
import 'package:offersapp/pages/web_view_screen.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:rxdart/rxdart.dart';
import 'package:offersapp/Config/app_pages.dart' as config1;
import 'package:offersapp/config/app_pages.dart' as config2;
import 'Config/app_pages.dart';
import 'app_deeplink.dart';
import 'config/app_pages.dart';
import 'config/app_route.dart';
import 'config/app_route.dart';
import 'firebase_options.dart';
import 'package:get/route_manager.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
  showBadge: true,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;
}

String? selectedNotificationPayload;

GlobalKey<NavigatorState> navigatorKeyMainPg = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  List data = [];
  data.add(remoteMessage.data);
  var payload = data[0]['openPage'];
  print('A bg message just showed up :  ${remoteMessage.data}');
  // NavigationService _navigationService = locator<NavigationService>();

  print(payload);
  // myNavigations(payload, data);
}

myNavigations(payload, data) {
  print('inside navigation');
  print('payload : $payload , data : $data');
  if (payload == 'Link') {
    navigatorKeyMainPg.currentState!.push(MaterialPageRoute(
        builder: (context) => WebViewScreen(
              link: data[0]['url'],
            )));
    // _navigationService.navigateTo(WorkInProgressDetails(vehicleNumber: data[0]['vehicle_number'],));
  } else if (payload == 'Offers') {
    navigatorKeyMainPg.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            OfferDetailsPage(data: null, id: data[0]['offerId'])));
    // _navigationService.navigateTo(WorkInProgressDetails(vehicleNumber: data[0]['vehicle_number'],));
  } else {
    print('add new payload type for navigation');
  }
}

Future<void> myfirebase() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      print(message.data);
      print('myyyy dataaa');
      List data = [];
      data.add(message.data);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: 'ic_notification', // Ensure this matches your icon resource name
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: jsonEncode(data),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(message.data);
    List data2 = [];
    data2.add(message.data);

    print(data2[0]['openPage']);
    var payload = data2[0]['openPage'];
    // myNavigations(payload, data2);
  });

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    print('get initial msg called.');
    print(initialMessage.data);
    List data2 = [];
    data2.add(initialMessage.data);

    var payload = data2[0]['openPage'];

    // myNavigations(payload, data2);
  }

  var details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (details!.didNotificationLaunchApp) {
    print('new new payload 22');
    // Handle notification launch details if needed
  }
}

late final FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLinksDeepLink.instance.initDeepLinks();

  //#222467
  // bg chagnes j2/24
  // final translator = GoogleTranslator();
  // var input = "नमस्ते"; // Example input in Hindi
  // var englishTranslation = await translator.translate(input, to: 'te');
  //print("Source: $input\nTranslated to English: $englishTranslation");
  //
  // var teluguTranslation = await translator.translate(input, to: 'te');
  // print("Source: $input\nTranslated to Telugu: $teluguTranslation");
  //
  // input = "Hello"; // Example input in English
  // var hindiTranslation = await translator.translate(input, to: 'hi');
  // print("Source: $input\nTranslated to Hindi: $hindiTranslation");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: primaryColor, // navigation bar color
    statusBarColor: AppColors.primaryDarkColor, // status bar color
  ));
  await ScreenUtil.ensureScreenSize();
  MobileAds.instance.initialize(); //<-- SEE HERE

  if (kDebugMode)
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ["C1E4BB6BF7CC212BD14A28E2F8585667"]),
    );
  //RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("C1E4BB6BF7CC212BD14A28E2F8585667"))

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    // selectedNotificationPayload = notificationAppLaunchDetails?.payload;
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  // final IOSInitializationSettings initializationSettingsIOS =
  // IOSInitializationSettings(
  //     requestAlertPermission: false,
  //     requestBadgePermission: true,
  //     requestSoundPermission: false,
  //     onDidReceiveLocalNotification:
  //         (int? id, String? title, String? body, String? payload) async {
  //       didReceiveLocalNotificationSubject.add(ReceivedNotification(
  //         id: id!,
  //         title: title!,
  //         body: body!,
  //       ));
  //     });
  //
  // const MacOSInitializationSettings initializationSettingsMacOS =
  // MacOSInitializationSettings(
  //     requestAlertPermission: false,
  //     requestBadgePermission: true,
  //     requestSoundPermission: false);
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsIOS,
  //     macOS: initializationSettingsMacOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //       selectedNotificationPayload = payload!;
  //       selectNotificationSubject.add(payload);
  //       var data = jsonDecode(payload);
  //       print(data);
  //
  //       print('new new payload');
  //       print(data[0]['openPage']);
  //       var payload2 = data[0]['openPage'];
  //       myNavigations(payload2, data);
  //     });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  myfirebase();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final AppLinksDeepLink _appLinksDeepLink = AppLinksDeepLink.instance;
  @override
  void initState() {
    super.initState();
    //initDynamicLinks2();
    //_initDynamicLinks();
    // initReferrerDetails();
    // _handleIncomingLinks();
    // _appLinksDeepLink.initDeepLinks();
    AppLinksDeepLink.instance.initDeepLinks();
    print(Uri.base.queryParameters);
    _localization.init(
      mapLocales: [
         MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'HDI',
          AppLocale.HDI,
          countryCode: 'IN',
          fontFamily: 'Font EN',
        ),
        const MapLocale(
          'TEL',
          AppLocale.TEL,
          countryCode: 'IN',
          fontFamily: 'Font EN',
        ),
      ],
      initLanguageCode: 'en',
    );

    _localization.onTranslatedLanguage = _onTranslatedLanguage;

    // initReferrerDetails();
    // print(Uri.base.queryParameters);
  }

  // void _handleIncomingLinks() async {
  //   // Handle deep links if the app is already opened
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //     final Uri? deepLink = dynamicLinkData.link;
  //     if (deepLink != null) {
  //       _handleDeepLink(deepLink);
  //     }
  //   }).onError((error) {
  //     print('onLinkError');
  //     print(error.message);
  //   });
  //
  //   // Handle deep links if the app is opened from a terminated state
  //   final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (initialLink != null) {
  //     final Uri? deepLink = initialLink.link;
  //     if (deepLink != null) {
  //       _handleDeepLink(deepLink);
  //     }
  //   }
  // }

  // void _handleDeepLink(Uri deepLink) {
  //   // Process the deep link, e.g., navigate to a specific screen
  //   final String? referralCode = deepLink.queryParameters['referral'];
  //   if (referralCode != null) {
  //     print('Referral code: $referralCode');
  //     // Handle the referral code, e.g., navigate to a referral screen
  //   }
  //
  //   // Handle other query parameters as needed
  // }
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  // var dynamicLink = StateProvider.autoDispose((ref) => '');
  var dynamicLink = StateProvider.autoDispose((ref) => '');

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  // Future<void> _initDynamicLinks() async {
  //   // Handle incoming dynamic links when the app is in the foreground
  //   FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
  //     _handleDynamicLink(dynamicLink);
  //   }).onError((error) async {
  //     print('onLink error');
  //     print(error.message);
  //   });
  //
  //   // Check for any dynamic link that the app was opened with
  //   final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (data != null) {
  //     _handleDynamicLink(data);
  //   }
  // }
  //
  // void _handleDynamicLink(PendingDynamicLinkData data) {
  //   final Uri? deepLink = data?.link;
  //
  //   if (deepLink != null) {
  //     // Parse the deep link and navigate accordingly
  //     if (deepLink.pathSegments.length > 0) {
  //       String screen = deepLink.pathSegments[0];
  //       if (screen == 'splashScreenPage') {
  //         // Navigate to a specific page based on the deep link
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => splashScreenPage()),
  //         );
  //       }
  //       // Add more navigation logic as needed
  //     }
  //   }
  // }

  initDynamicLinks() async {
    print('inside');
    PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    print(data);
    if (data != null) {
      print('dynamiclink');
      print(data.link.data);
      var a = data.link.queryParameters;
      // print(a['referalToken']);
      showSnackBar(context, a.toString());
      // ref.read(dynamicLink.state).state = a['referalToken'].toString();
    }
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      print('dynamiclink');
      var a = dynamicLinkData.link.queryParameters;
      showSnackBar(context, a.toString());
      print(a['referalToken']);
      ref.read(dynamicLink.state).state = a['referalToken'].toString();
      // print(dynamicLinkData.link.data!.contentText);
      // print(dynamicLinkData.link.query);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  initDynamicLinks2() async {
    var newData = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = newData!.link;
    if (deepLink != null) {
      // Handle the deep link
      // Extract the UTM parameters from the deep link
      var utmSource = deepLink.queryParameters['utm_source'];
      var utmMedium = deepLink.queryParameters['utm_medium'];
      var utmCampaign = deepLink.queryParameters['utm_campaign'];

      // Log UTM parameters to Firebase Analytics
      _logUTMParameters({
        'utm_source': utmSource,
        'utm_medium': utmMedium,
        'utm_campaign': utmCampaign,
      });

      print('UTM Source: $utmSource');
      print('UTM Medium: $utmMedium');
      print('UTM Campaign: $utmCampaign');
    }
    // showSnackBar(context, 'UTM Camping');
    print('THIS IS UTM CM');
  }

  void _logUTMParameters(utmParams) {
    FirebaseAnalytics.instance.logEvent(
      name: 'utm_parameters',
      parameters: utmParams,
    );
  }

  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.toString();
      print(referrerDetailsString);
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      // Update state safely
    });
    // ref.read(dynamicLink.notifier).state = referrerDetailsString;
    // print(referrerDetailsString);
    // showSnackBar(context, referrerDetailsString);
  }

  @override
  Widget build(BuildContext context) {
    _appLinksDeepLink.initDeepLinks();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      //figma reference
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Turbo Paisa',
          supportedLocales: _localization.supportedLocales,
          localizationsDelegates: _localization.localizationsDelegates,
          navigatorKey: navigatorKeyMainPg,
          debugShowCheckedModeBanner: false,
          getPages: config1.AppPages.routes,
          initialRoute: config2.AppPages.initial,
          theme: ThemeData(
            primaryColor: AppColors.primaryColor1,
            colorScheme:
            ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
            // fontFamily: "Poppins"
            textTheme:
            GoogleFonts.poppinsTextTheme(), //.apply(fontSizeFactor: 1.sp),
            // useMaterial3: true,
          ),
          // home: UpgradeAlert(
          //     upgrader: Upgrader(
          //       upgraderDevice: UpgraderDevice()
          //     ),
          //     child: SplashScreenPage()),
          // home: Scaffold(body: SplashScreenPage()), // run this for login and out works
          // home: VerificationPage(),
        );
      },
    );
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primaryColor: AppColors.primaryColor1,
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     // fontFamily: "Poppins"
    //     textTheme: GoogleFonts.poppinsTextTheme(),
    //     // useMaterial3: true,
    //   ),
    //   // home: SplashScreenPage(),
    //   home: RegistrationPageNew(),
    // );
  }
}

