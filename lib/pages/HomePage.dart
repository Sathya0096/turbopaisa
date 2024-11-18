import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:offersapp/api/api_services/my_offers_service.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/model/WalletResponse.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/earn_on_games.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/offer_details_page.dart';
import 'package:offersapp/pages/scratch_card_list_page.dart';
import 'package:offersapp/pages/scratch_card_page.dart';
import 'package:offersapp/pages/task_page.dart';
import 'package:offersapp/pages/tutorial_page.dart';
import 'package:offersapp/pages/update_screen.dart';
import 'package:offersapp/pages/wallet_page.dart';
import 'package:offersapp/pages/web_view_screen.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:offersapp/widgets/banner_ad.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:translator/translator.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Config/app_route.dart';
import '../api/apiEndpoints.dart';
import '../api/api_provider.dart';
import '../api/api_services/network_error.dart';
import '../api/api_services/wallet_service.dart';
import '../api/model/BannersResponse.dart';
import '../api/restclient.dart';
import 'bonus_controller.dart';
import 'dashboard_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dynamic_link_services.dart';
import 'language_Screen.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
          onStart: (index, key) {
            // Log can be removed if not needed
          },
          onComplete: (index, key) {
            if (index == 4) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle.light.copyWith(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white,
                ),
              );
            }
          },
          blurValue: 1,
          autoPlayDelay: const Duration(seconds: 3),
          builder: (context) => const HomePage1(
                referralCode: '',
              )),
    );
  }
}

class HomePage1 extends ConsumerStatefulWidget {
  const HomePage1({Key? key, required String referralCode}) : super(key: key);

  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends ConsumerState<HomePage1>
    with SingleTickerProviderStateMixin {
  final String _url = 'https://whatsapp.com/channel/0029VajFvE1IHphQfHKMkM1C';
  bool isTaskLoadings = false;
  Map<String, dynamic>? responseData;
  int taskCount = 0;
  bool _isFirstInstallation = true;

  Future<void> _initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }

      linkStream.listen((String? link) {
        if (link != null) {
          _handleLink(link);
        }
      });
    } catch (e) {
      print('Failed to get initial link or listen to link stream: $e');
    }
  }

  void _handleLink(String link) {
    if (link.contains('/services/device')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // final String _urls = 'https://www.youtube.com/shorts/YpBZUKCi0f0';

  String tutorialLink = ''; // Field to stor
  // String tutorialLinks = ''; // Field to stor
  ApiStatus status = ApiStatus.Stable;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isCollectEnabled = true;
  List<bool> _streaks = [false, false, false];
  int _currentStreak = 0;

  // void _handleDynamicLinks() async {
  //   final PendingDynamicLinkData? initialLink =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (initialLink?.link != null) {
  //     _handleLink(initialLink!.link);
  //   }
  //
  //   FirebaseDynamicLinks.instance.onLink
  //       .listen((PendingDynamicLinkData dynamicLinkData) {
  //     _handleLink(dynamicLinkData.link);
  //   }).onError((error) {
  //     debugPrint('Error in onLink: $error');
  //   });
  // }
  //
  // void _handleLink(Uri uri) {
  //   // Parse the link and navigate to the appropriate page
  //   if (uri.queryParameters['referral'] != null) {
  //     final referral = uri.queryParameters['referral'];
  //     debugPrint('Referral code: $referral');
  //
  //     // Navigate to a specific page based on the referral or other parameters
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => HomePage1(referralCode: referral!)),
  //     );
  //   } else {
  //     // Navigate to the home page
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage1(referralCode: '',)),
  //     );
  //   }
  // }

  // Future<void> _handleDynamicLinks() async {
  //   final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   _handleLink(data?.link);
  //
  //   FirebaseDynamicLinks.instance.onLink.listen((event) {
  //     _handleLink(event.link);
  //   }).onError((error) {
  //     // Handle error
  //   });
  // }

  // void _handleLink(Uri? link) {
  //   if (link != null) {
  //     if (link.path == '/offerPage') {
  //       Navigator.pushNamed(context, '/offerPage');
  //     } else {
  //       // Handle other links or fallback
  //     }
  //   }
  // }

  void _launchURLChrome(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await custom_tabs.launchUrl(
        Uri.parse('https://8073.play.gamezop.com'),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(
              // toolbarColor: theme.colorScheme.surface,
              ),
          shareState: custom_tabs.CustomTabsShareState.off,
          // urlBarHidingEnabled: true,
          // showTitle: true,
          closeButton: custom_tabs.CustomTabsCloseButton(
            icon: custom_tabs.CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }

  void _launchURLS(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await custom_tabs.launchUrl(
        Uri.parse('https://8362.play.quizzop.com'),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: custom_tabs.CustomTabsShareState.off,
          urlBarHidingEnabled: true,
          // showTitle: true,
          closeButton: custom_tabs.CustomTabsCloseButton(
            icon: custom_tabs.CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }

  void _launchURLWhatsApp() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  Map<String, dynamic> dailyLogin = {};

  // void _launchURLYoutube() async {
  //   if (await canLaunch(_urls)) {
  //     await launch(_urls);
  //   } else {
  //     throw 'Could not launch $_urls';
  //   }
  // }

  void _launchURL() async {
    const url = 'https://8073.play.gamezop.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // void _launchURLS() async {
  //   const url = 'https://8362.play.quizzop.com';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  String truncateText(String text, int wordCount) {
    List<String> words = text.split(' ');
    if (words.length <= wordCount) {
      return text;
    } else {
      return words.take(wordCount).join(' ') + '...';
    }
  }

  int _selectedIndex = 0;
  bool isLoading = false;
  var groupValue = 0;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
  final FlutterLocalization _localization = FlutterLocalization.instance;

  WalletResponse? walletResponse;

  final PageController _pageController = PageController();

  // final NotchBottomBarController notchBottomBarController =
  // NotchBottomBarController(index: 1);

  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  var offerProvider = ChangeNotifierProvider((ref) => OffersProvider());
  final BonusController bonusController = Get.put(BonusController());

// Local integer variable to hold the fetched value
  String frbvn = '0';
  String localVn = '18.13.0';
  final translator = GoogleTranslator();

  Future<String> translateText(String inputText) async {
    // print('THIS IS LOCAL LANG ${_localization.currentLocale}');
    // print('this is calls ok');
    var translation = await translator.translate(inputText,
        to: _localization.currentLocale.toString() == 'en_US'
            ? 'en'
            : _localization.currentLocale.toString() == 'HDI_IN'
                ? 'hi'
                : 'te');
    return translation.toString();
  }

// Function to fetch integer value from the first document in a collection and update local variable
  Future<void> fetchAndUpdateIntValue() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    const String collectionName =
        'version'; // Replace with your collection name
    const String fieldName = 'version'; // Replace with your field name

    try {
      // Fetch the first document from the collection
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey(fieldName)) {
          frbvn = data[fieldName];
          print('Value updated to: $frbvn');
        } else {
          print('Field $fieldName does not exist in the document');
        }
      } else {
        print('No documents found in the collection $collectionName');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//   checkAppVersion() async {
//     await fetchAndUpdateIntValue();
//     if (frbvn != localVn) Get.toNamed(Routes.update);
//   }
  Future<void> _fetchDetails() async {
    setState(() {
      status = ApiStatus.Loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    var data =
        jsonDecode(user!); // Adjust this line based on your `UserData` class

    var response = await ApiProvider.post(
      url: ApiEndPoints.getSettingsInfo,
      body: {'user_id': data['userId'].toString()},
    );

    if (response['status'] == 200) {
      setState(() {
        status = ApiStatus.Success;
        var res = jsonDecode(response['body']);
        tutorialLink = res['resultMessage']['tutorial_link'].toString();
      });
    } else if (response['status'] == 'No Connection') {
      setState(() {
        status = ApiStatus.NetworkError;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NetworkError()),
      );
    } else {
      setState(() {
        status = ApiStatus.Error;
      });
    }
  }

  Future<void> _launchURLYoutube(String url) async {
    print('Attempting to launch URL: $url'); // Debug print
    if (url.isEmpty) {
      url =
          'https://www.youtube.com/shorts/uzilJ86lYNc'; // Hardcoded URL for testing
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch URL: $url'); // Debug print
      throw 'Could not launch $url';
    }
  }

  // Future<void> _fetchOfferDetails() async {
  //   setState(() {
  //     status = ApiStatus.Loading;
  //   });
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var user = await prefs.getString("user");
  //   var data =
  //       jsonDecode(user!); // Adjust this line based on your `UserData` class
  //
  //   var response = await ApiProvider.post(
  //     url: ApiEndPoints.getSettingsInfo,
  //     body: {'user_id': data['userId'].toString()},
  //   );
  //
  //   if (response['status'] == 200) {
  //     setState(() {
  //       status = ApiStatus.Success;
  //       var res = jsonDecode(response['body']);
  //       tutorialLinks = res['resultMessage']['tutorial_link'].toString();
  //     });
  //   } else if (response['status'] == 'No Connection') {
  //     setState(() {
  //       status = ApiStatus.NetworkError;
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const NetworkError()),
  //     );
  //   } else {
  //     setState(() {
  //       status = ApiStatus.Error;
  //     });
  //   }
  // }

  Future<void> _launchURLYoutubeOfferDetails(String url) async {
    print('Attempting to launch URL: $url'); // Debug print
    if (url.isEmpty) {
      url =
          'https://www.youtube.com/shorts/uzilJ86lYNc'; // Hardcoded URL for testing
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch URL: $url'); // Debug print
      throw 'Could not launch $url';
    }
  }

  Future<void> _checkAndShowPopup() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownDate = prefs.getString('last_popup_date');
    final todayDate = DateTime.now().toIso8601String().substring(0, 10);

    if (lastShownDate == null || lastShownDate != todayDate) {
      // Show the popup
      _showPopup(context);

      // Save today's date to SharedPreferences
      await prefs.setString('last_popup_date', todayDate);
    }
  }

  void _showPopup(BuildContext context) {
    bonusController.checkUserStatus();
    bonusController.checkUserStatusTwo();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xffF3F6FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.close),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/badge.png',
                    fit: BoxFit.cover,
                    width: 42,
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'DAILY BONUS',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffED3E55)),
                          ),
                        ],
                      ),
                      Text(
                        'Participate and win Extra TP points',
                        style: TextStyle(fontSize: 9, color: Color(0xff3D3FB5)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDailyLoginItem(context),
              _buildMaintainStreakItem(context),
              _buildCompleteTasksItem(context),
            ],
          ),
        );
      },
    );
  }

  // static String daily5Points = 'https://dev.turbopaisa.com/services/users/check_user_status';

  // TODO API 1
  // Future<void> _fetchDetails5Points() async {
  //   print('Fetching details...');
  //   try {
  //     setState(() {
  //       isTaskLoadings = true; // Set loading state to true
  //     });
  //
  //     final url = Uri.parse(
  //         'https://dev.turbopaisa.com/services/users/check_user_status');
  //     final headers = {'Content-Type': 'application/json'};
  //     final body = jsonEncode({
  //       // Add any required POST data here
  //     });
  //
  //     final response = await http.post(url, headers: headers, body: body);
  //
  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       // Parse the JSON response
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //       print('Parsed Response Data: $responseData');
  //
  //       if (responseData['daily_login']['status'] == "error") {
  //         // Handle the error case
  //         print('Error Message: ${responseData['daily_login']['message']}');
  //         // Optionally show an error message to the user
  //       } else {
  //         // Handle success case
  //         final int fetchedTaskCount =
  //             responseData['daily_login']['task_count'];
  //
  //         print('Fetched Task Count: $fetchedTaskCount');
  //
  //         // Update the UI or state based on the response
  //         setState(() {
  //           taskCount = fetchedTaskCount; // Update taskCount
  //         });
  //
  //         print('Updated Task Count in State: $taskCount');
  //       }
  //     } else {
  //       print('Failed to load data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     setState(() {
  //       isTaskLoadings = false; // Reset loading state
  //     });
  //   }
  // }

  // Future<void> _fetchDetails5Points() async {
  //   setState(() {
  //     status = ApiStatus.Loading;
  //   });
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     if (user == null) {
  //       // Handle case where user data is not available
  //       setState(() {
  //         status = ApiStatus.Error;
  //       });
  //       return;
  //     }
  //
  //     var data = jsonDecode(user); // Adjust this line based on your `UserData` class
  //
  //     var response = await ApiProvider.post(
  //       url: daily5Points,
  //       body: {'user_id': data['userId'].toString()},
  //     );
  //
  //     if (response['status'] == 200) {
  //       setState(() {
  //         status = ApiStatus.Success;
  //         var res = jsonDecode(response['body']);
  //
  //         // Assuming the response body contains the following structure
  //         var dailyLogin = res['daily_login'];
  //
  //         String apiStatus = dailyLogin['status'];
  //         String message = dailyLogin['message'];
  //         String streakCount = dailyLogin['streak_count'];
  //         int taskCount = dailyLogin['task_count'];
  //
  //         print('API Status: $apiStatus');
  //         print('Message: $message');
  //         print('Streak Count: $streakCount');
  //         print('Task Count: $taskCount');
  //       });
  //     } else if (response['status'] == 'No Connection') {
  //       setState(() {
  //         status = ApiStatus.NetworkError;
  //       });
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const NetworkError()),
  //       );
  //     } else {
  //       setState(() {
  //         status = ApiStatus.Error;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       status = ApiStatus.Error;
  //     });
  //     print('An error occurred: $e');
  //   }
  // }

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  Widget _buildDailyLoginItem(BuildContext context) {
    // bool isCompleted = _streaks[0];
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 38.33,
            offset: Offset(2.32, 8),
            spreadRadius: 0,
          )
        ],
      ),
      // height: 72,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Daily Log in',
                        style: TextStyle(
                            fontSize: 7.7, fontWeight: FontWeight.bold)),
                    const Text(' ~ 5 TP Point',
                        style: TextStyle(
                            fontSize: 6.7,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffED3E55))),
                    const SizedBox(width: 2),
                    SizedBox(
                        height: 13,
                        child: Image.asset('assets/images/tp_coin.png')),
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      return InkWell(
                        onTap: bonusController.dailyCollected.value
                            ? null
                            : bonusController.collectDailyBonus,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: bonusController.dailyCollected.value
                                ? const Color(0xffED3E55).withOpacity(0.70)
                                : const Color(0xffED3E55),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text('Collect',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            const Text('Login Daily to get a TP Point for Free!',
                style: TextStyle(fontSize: 8)),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 7,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xff3D3FB5))),
                  child: Obx(() => LinearProgressIndicator(
                        value: bonusController.dailyProgress.value,
                      )),
                  // Row(
                  //   children: List.generate(
                  //     1,
                  //         (index) =>
                  //         Container(
                  //           height: 5,
                  //           width: 180,
                  //           margin: const EdgeInsets.symmetric(horizontal: 1),
                  //           color: isCompleted ? Colors.blue : Colors.grey,
                  //         ),
                  //   ),
                  // ),
                ),
                // SizedBox(width: 14),
                Obx(() {
                  return Text(
                    bonusController.timeLeft.value,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffED3E55)),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // static String dailyStreak = 'https://dev.turbopaisa.com/services/users/claim_streak_bonus';

  // Future<void> _fetchDetailsStreak() async {
  //   setState(() {
  //     status = ApiStatus.Loading;
  //   });
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var user = await prefs.getString("user");
  //   var data = jsonDecode(user!); // Adjust this line based on your `UserData` class
  //
  //   var response = await ApiProvider.post(
  //     url: dailyStreak, // Updated to use the new `dailyStreak` URL
  //     body: {'user_id': data['userId'].toString()},
  //   );
  //
  //   if (response['status'] == 200) {
  //     setState(() {
  //       status = ApiStatus.Success;
  //       var res = jsonDecode(response['body']);
  //
  //       // Extract the task_completion field
  //       var taskCompletion = res['task_completion'];
  //
  //       String taskCompletionStatus = taskCompletion['status'];
  //       String taskCompletionMessage = taskCompletion['message'];
  //
  //       // Log or use these values as per your application logic
  //       print('Task Completion Status: $taskCompletionStatus');
  //       print('Task Completion Message: $taskCompletionMessage');
  //     });
  //   } else if (response['status'] == 'No Connection') {
  //     setState(() {
  //       status = ApiStatus.NetworkError;
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const NetworkError()),
  //     );
  //   } else {
  //     setState(() {
  //       status = ApiStatus.Error;
  //     });
  //   }
  // }

  Widget _buildMaintainStreakItem(BuildContext context) {
    // bool isCompleted = _streaks[1];
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 38.33,
            offset: Offset(2.32, 8),
            spreadRadius: 0,
          )
        ],
      ),
      // height: 72,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Maintain 10 Days Streak',
                        style: TextStyle(
                            fontSize: 7.7, fontWeight: FontWeight.bold)),
                    const Text(' ~ 100 TP Points',
                        style: TextStyle(
                            fontSize: 6.7,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffED3E55))),
                    const SizedBox(width: 2),
                    SizedBox(
                        height: 13,
                        child: Image.asset('assets/images/tp_coin.png')),
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      return InkWell(
                        onTap: bonusController.streakDays.value >= 10
                            ? () {
                                bonusController.collectTenDaysBonus();
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: bonusController.streakDays.value >= 10
                                ? const Color(0xffED3E55)
                                : const Color(0xffED3E55).withOpacity(0.70),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text('Collect',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            const Text('Maintain daily login for streak',
                style: TextStyle(fontSize: 8)),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 7,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xff3D3FB5))),
                  child: Obx(() => LinearProgressIndicator(
                        value: bonusController.streakProgress.value,
                      )),
                ),
                Obx(() {
                  return Text(
                    '${bonusController.streakDays.value}/10 Days',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffED3E55)),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // static String dailyTasks = 'https://dev.turbopaisa.com/services/users/claim_task_bonus';

  Future<void> _fetchDetailsTasks() async {
    setState(() {
      status = ApiStatus.Loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    var data =
        jsonDecode(user!); // Adjust this line based on your `UserData` class

    var response = await ApiProvider.post(
      url: ApiEndPoints.getSettingsInfo,
      body: {'user_id': data['userId'].toString()},
    );

    if (response['status'] == 200) {
      setState(() {
        status = ApiStatus.Success;
        var res = jsonDecode(response['body']);

        var taskCompletion = res['task_completion'];

        String taskCompletionStatus = taskCompletion['status'];
        String taskCompletionMessage = taskCompletion['message'];

        // Log or use these values as per your application logic
        print('Task Completion Status: $taskCompletionStatus');
        print('Task Completion Message: $taskCompletionMessage');
      });
    } else if (response['status'] == 'No Connection') {
      setState(() {
        status = ApiStatus.NetworkError;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NetworkError()),
      );
    } else {
      setState(() {
        status = ApiStatus.Error;
      });
    }
  }

  Widget _buildCompleteTasksItem(BuildContext context) {
    // bool isCompleted = _streaks[2];
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 38.33,
            offset: Offset(2.32, 8),
            spreadRadius: 0,
          )
        ],
      ),
      // height: 75,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Complete 5 Tasks',
                        style: const TextStyle(
                            fontSize: 8, fontWeight: FontWeight.bold)),
                    const Text(' ~ 250 TP Points',
                        style: const TextStyle(
                            fontSize: 6.7,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffED3E55))),
                    const SizedBox(width: 2),
                    SizedBox(
                        height: 13,
                        child: Image.asset('assets/images/tp_coin.png')),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: bonusController.tasksCompleted.value >= 5
                          ? bonusController.collectTaskBonus
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: bonusController.tasksCompleted.value >= 5
                              ? const Color(0xffED3E55)
                              : const Color(0xffED3E55).withOpacity(0.70),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text('Collect',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Text('Complete 5 tasks within 10 days',
                style: TextStyle(fontSize: 8)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 7,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: const Color(0xff3D3FB5))),
                  child: Obx(() => LinearProgressIndicator(
                        value: bonusController.taskProgress.value,
                      )),
                ),
                Row(
                  children: [
                    Obx(() {
                      return Text(
                        '${bonusController.tasksCompleted.value}/5 Tasks',

                        // '${dailyLogin['task_count'] ?? 0}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffED3E55)),
                      );
                    }),
                    // Text(
                    //   '/5 Tasks',
                    //   style: const TextStyle(
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.bold,
                    //       color: Color(0xffED3E55)),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startCountdown() {
    setState(() {
      _isCollectEnabled = false;
      _remainingSeconds = 24 * 60 * 60; // 24 hours in seconds
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          _isCollectEnabled = true;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatRemainingTime() {
    int hours = (_remainingSeconds / 3600).floor();
    int minutes = ((_remainingSeconds % 3600) / 60).floor();
    int seconds = _remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleCollect(int index) {
    if (!_isCollectEnabled) return;

    setState(() {
      _streaks[index] = true;
      _startCountdown();
      _currentStreak++;
    });

    if (_currentStreak >= 5) {}
  }

  // int currentStep = 0;
  late TabController _tabController;

  void _checkFirstInstall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstInstall = prefs.getBool('isFirstInstall') ?? true;

    if (isFirstInstall) {
      prefs.setBool('isFirstInstall', false);
      // The user is seeing the guide for the first time, so nothing to do here
    } else {
      // Navigate to your main screen instead
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => TaskGuideScreen()),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAndShowPopup();
    _checkShowcaseStatus();
    _initUniLinks();

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => ShowCaseWidget.of(context)
    //       .startShowCase([_one, _two, _three, _four, _five]),
    // );
    // _handleDynamicLinks();
    // setState(() {
    //   // _localization.currentLocale
    //   // print('THIS IS CALLING INTEX');
    // });
    //checkAppVersion();

    _fetchDetailsTasks();
    _fetchDetails();
    //_fetchDetails5Points();
    scrollController.addListener(pagination);
    _futureData = loadData();
    loadBannersData();
    loadWallet();
    updateFcm();
    requestNotificationPermissions();
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      print('got inside');
      InAppUpdate.startFlexibleUpdate().then((_) {
        InAppUpdate.completeFlexibleUpdate().then((_) {
          MySnackbarSuccess(context, "Success!");
        }).catchError((e) {
          print(e.toString());
        });
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  bool _showcaseShown = false;

  Future<void> _checkShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showcaseShown = prefs.getBool('showcase_shown') ?? false;
    });

    if (!_showcaseShown) {
      await Future.delayed(Duration(milliseconds: 6000));
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(
          [
            _one,
            _two,
            _three,
            _four,
            _five,
          ],
        ),
      );
      _setShowcaseStatus();
    }
  }

  Future<void> _setShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showcase_shown', true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  updateFcm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    FirebaseMessaging Fcm = FirebaseMessaging.instance;
    var token = await Fcm.getToken();
    print(token);
    var res = await ref.read(offerProvider).updateFcmToken(
      context: context,
      ref: ref,
      body: {
        'userId': data.userId,
        'deviceId': token,
        'mobile': data.mobile,
        'androidId': data.mobile,
      },
    );
  }

  var scrollController = ScrollController();
  static const int PAGE_SIZE = 10;
  int start = 1;
  Future<List<OffersData>>? _futureData;

  void pagination() {
    if (isLoading) {
      return;
    }
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      setState(() {
        isLoading = true;
        start = start + 1; //+= PAGE_SIZE;
        if (_selectedIndex == 0) {
          print('pageNumber 1 : $start');
        } else if (_selectedIndex == 1) {
        } else if (_selectedIndex == 2) {}
      });
    }
  }

  RefreshController refreshcontroller =
      RefreshController(initialRefresh: false);

  Future<void> loadWallet() async {
    try {
      setState(() {
        isLoading = true;
      });
      // final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));

      print(start);
      // WalletResponse scratchCardResponse =
      //     await client.getTransactions(data.userId ?? "", start, PAGE_SIZE);
      var res = await ref.read(walletProvider).transactions(
            context: context,
            ref: ref,
            count: '10',
            pagenumber: start.toString(),
            user_id: data.userId,
          );
      if (res == true) {
        var data = ref.watch(walletProvider).data.first;
        setState(() {
          if (start == 1) {
            walletResponse = data;
          } else {
            walletResponse?.transactions?.addAll(data.transactions ?? []);
          }
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget buildTopOptions(String image, Color color, String title) {
    return Column(
      children: [
        // CircleAvatar(
        //   radius: 35,
        //   backgroundColor: Colors.white,
        //   child: CircleAvatar(
        //     radius: 30,
        //     backgroundColor: color,
        //     child: Image.asset(
        //       image,
        //       fit: BoxFit.contain,
        //     ),
        //   ),
        // ),
        Container(
          width: 64.w,
          height: 64.h,
          // decoration: ShapeDecoration(
          //   color: color, //Color(0xFFF0DA40),
          //   shape: RoundedRectangleBorder(
          //     side: BorderSide(width: 1, color: Color(0xFFF3F6FF)),
          //     borderRadius: BorderRadius.circular(464),
          //   ),
          // ),
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(
                width: 2.w,
                color: const Color(0xFFF3F6FF),
              ),
            ),
            shape: BoxShape.circle, color: color, //Color(0xFFF0DA40),
          ),
          child: Image.asset(
            image,
            // fit: BoxFit.fill,
            width: 42.w,
            height: 42.h,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Opacity(
          opacity: 0.90,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 9.sp,
              // fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.84,
            ),
          ),
        ),
        // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    // double popupWidth = 180;
    // double popupHeight = 160;
    // var currentPage = ref.watch(offerProvider).myOfferCurrentPage;
    // var lastPage = ref.watch(offerProvider).myOfferLastPage;
    double clipperHeight = 160.0;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: GreenClipper(),
                  child: Container(
                    height: clipperHeight,
                    color: const Color(0xff3D3FB5),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ClipRRect(
                      //   child:
                      Image.asset(
                        'assets/images/profile_avatar.png',
                        fit: BoxFit.cover,
                        width: 32.w,
                        // height: 200,
                        //height: 100,
                        // ),
                      ),
                      InkWell(
                        onTap: () {
                          _showPopup(context);
                          // Get.toNamed(Routes.TimerTestingToday);
                        },
                        child: Image.asset(
                          'assets/images/gift.png',
                          color: Colors.white,
                          fit: BoxFit.cover,
                          width: 32.w,
                        ),
                      ),

                      Image.asset(
                        Assets.imagesHomeLogo,
                        width: 111.w,
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          // margin: EdgeInsets.all(5),2
                          color: AppColors.primaryDarkColor.withOpacity(0.5),
                        ),
                        // padding: EdgeInsets.all(20),
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             WalletBalacePage()));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const WalletBalacePage()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Image.asset(
                                    color: Colors.black,
                                    'assets/images/wallet_icon.png',
                                    fit: BoxFit.contain,
                                    width: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // InkWell(
                              //   onTap: () {
                              //     // Navigator.pop(context, 1); // Return index 1 to the previous screen
                              //
                              //     // notchBottomBarController.jumpTo(1);
                              //     // final provider = Provider.of<NotchBottomBarController>(context, listen: false);
                              //     //Provider.of<NotchBottomBarController>(context).jumpTo;
                              //     // int newIndex = 1;
                              //     // _onItemTapped(newIndex);
                              //     // Navigator.push(
                              //     //   context,
                              //     //   MaterialPageRoute(builder: (context) => BottomNavBar(initialIndex: 1)),
                              //     // );
                              //
                              //   },
                              //   child:
                              Row(
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Image.asset(
                                        'assets/images/tp_coin.png'),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.0"}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.sp,
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 1.84,
                                    ),
                                  ),
                                ],
                              ),
                              //          ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: clipperHeight * 0.50,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                navigateToNext(context, const TaskListPage());
                              },
                              // child: buildTopOptions(
                              //     "assets/images/img.png",
                              //     const Color(0xFFF0DB40),
                              //     AppLocale.task.getString(context)
                              // ),
                              child: Column(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 35,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundColor: color,
                                  //     child: Image.asset(
                                  //       image,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: 64.w,
                                    height: 64.h,
                                    // decoration: ShapeDecoration(
                                    //   color: color, //Color(0xFFF0DA40),
                                    //   shape: RoundedRectangleBorder(
                                    //     side: BorderSide(width: 1, color: Color(0xFFF3F6FF)),
                                    //     borderRadius: BorderRadius.circular(464),
                                    //   ),
                                    // ),
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          width: 2.w,
                                          color: const Color(0xFFF3F6FF),
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      color: const Color(
                                          0xFFF0DB40), //Color(0xFFF0DA40),
                                    ),
                                    child: Showcase.withWidget(
                                      disableMovingAnimation: true,
                                      key: _one,
                                      height: 50,
                                      width: 140,
                                      targetShapeBorder: const CircleBorder(),
                                      targetBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(46),
                                      ),
                                      container: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 23, bottom: 10, top: 2),
                                            child: Text(
                                              "Task ",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12, top: 12),
                                                  child: Text(
                                                    'Task',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  height: 1.5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.428,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            '• Here you can find all',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const Text(
                                                            '  the offers.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 7),
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '• Follow the steps,',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            '  complete the task and',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            '  get your points.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .dismiss();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: const Text(
                                                                'Skip',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff3D3FB4),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 40),
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .startShowCase(
                                                                      [_two]);
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xff3D3FB4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Next',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        "assets/images/img.png",
                                        // fit: BoxFit.fill,
                                        width: 42.w,
                                        height: 42.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Opacity(
                                    opacity: 0.90,
                                    child: Text(
                                      AppLocale.task.getString(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.84,
                                      ),
                                    ),
                                  ),
                                  // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                navigateToNext(
                                    context, const ScratchCardListPage());
                              },
                              // child: buildTopOptions(
                              //     "assets/images/scratch_card_image.png",
                              //     const Color(0xFF70E2FE),
                              //     AppLocale.scratchCard.getString(context)
                              // ),
                              child: Column(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 35,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundColor: color,
                                  //     child: Image.asset(
                                  //       image,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: 64.w,
                                    height: 64.h,
                                    // decoration: ShapeDecoration(
                                    //   color: color, //Color(0xFFF0DA40),
                                    //   shape: RoundedRectangleBorder(
                                    //     side: BorderSide(width: 1, color: Color(0xFFF3F6FF)),
                                    //     borderRadius: BorderRadius.circular(464),
                                    //   ),
                                    // ),
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          width: 2.w,
                                          color: const Color(0xFFF3F6FF),
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      color: const Color(
                                          0xFF70E2FE), //Color(0xFFF0DA40),
                                    ),
                                    child: Showcase.withWidget(
                                      disableMovingAnimation: true,
                                      key: _two,
                                      height: 10,
                                      width: 134,
                                      targetShapeBorder: const CircleBorder(),
                                      targetBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(46),
                                      ),
                                      container: Column(
                                        children: <Widget>[
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "Scratch Card ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 12, left: 12),
                                                  child: Text(
                                                    'Scratch Card',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.424,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            '• Get variety of Brand',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const Text(
                                                            '  Vouchers through',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            '  scratch cards.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .dismiss();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: const Text(
                                                                'Skip',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff3D3FB4),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 40),
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .startShowCase(
                                                                      [_three]);
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xff3D3FB4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Next',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        "assets/images/scratch_card_image.png",
                                        // fit: BoxFit.fill,
                                        width: 42.w,
                                        height: 42.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Opacity(
                                    opacity: 0.90,
                                    child: Text(
                                      AppLocale.scratchCard.getString(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.84,
                                      ),
                                    ),
                                  ),
                                  // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _launchURLS(context);
                                //_launchURLS();
                                // navigateToNext(
                                //     context,
                                //     WebViewScreen(
                                //         link:
                                //         'https://8362.play.quizzop.com'
                                //  ));
                              },
                              // child: buildTopOptions(
                              //     "assets/images/survey_image.png",
                              //     const Color(0xFFF58967),
                              //     AppLocale.quiz.getString(context)),
                              child: Column(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 35,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundColor: color,
                                  //     child: Image.asset(
                                  //       image,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: 64.w,
                                    height: 64.h,
                                    // decoration: ShapeDecoration(
                                    //   color: color, //Color(0xFFF0DA40),
                                    //   shape: RoundedRectangleBorder(
                                    //     side: BorderSide(width: 1, color: Color(0xFFF3F6FF)),
                                    //     borderRadius: BorderRadius.circular(464),
                                    //   ),
                                    // ),
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          width: 2.w,
                                          color: const Color(0xFFF3F6FF),
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      color: const Color(
                                          0xFFF58967), //Color(0xFFF0DA40),
                                    ),
                                    child: Showcase.withWidget(
                                      disableMovingAnimation: true,
                                      key: _three,
                                      height: 10,
                                      width: 140,
                                      targetShapeBorder: const CircleBorder(),
                                      targetBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      container: Column(
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                right: 52, bottom: 10, top: 3),
                                            child: Text(
                                              "Quiz",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 12, left: 65),
                                                  child: Text(
                                                    'Quiz',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  height: 1.5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.522,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            '• Spare your free time',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const Text(
                                                            '  to build your IQ levels with',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const Text(
                                                            '  Quiz.',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .dismiss();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: const Text(
                                                                'Skip',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff3D3FB4),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 40),
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .startShowCase(
                                                                      [_four]);
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xff3D3FB4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Next',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        "assets/images/survey_image.png",
                                        // fit: BoxFit.fill,
                                        width: 42.w,
                                        height: 42.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Opacity(
                                    opacity: 0.90,
                                    child: Text(
                                      AppLocale.quiz.getString(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.84,
                                      ),
                                    ),
                                  ),
                                  // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _launchURLChrome(context);
                                // uncomment below 2 lines for game zone
                                // navigateToNext(
                                //     context, const EarOnGamesPage());
                                // navigateToNext(
                                //     context,
                                //     WebViewScreen(
                                //         link: // Call this method where you need to perform the redirection
                                //             _launchURL
                                //
                                //         //'https://8073.play.gamezop.com/en/intro?int-nav=1#google_vignette'
                                //         ));
                                // Navigator.of(context).push(
                                //   TutorialOverlay(
                                //     child: ScratchCardPage(),
                                //   ),
                                // );
                              },
                              // child: buildTopOptions(
                              //     "assets/images/earn_on_games_image.png",
                              //     const Color(0xFFFF9EB7),
                              //     AppLocale.freeGames.getString(context)),
                              child: Column(
                                children: [
                                  // CircleAvatar(
                                  //   radius: 35,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     radius: 30,
                                  //     backgroundColor: color,
                                  //     child: Image.asset(
                                  //       image,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: 64.w,
                                    height: 64.h,
                                    // decoration: ShapeDecoration(
                                    //   color: color, //Color(0xFFF0DA40),
                                    //   shape: RoundedRectangleBorder(
                                    //     side: BorderSide(width: 1, color: Color(0xFFF3F6FF)),
                                    //     borderRadius: BorderRadius.circular(464),
                                    //   ),
                                    // ),
                                    decoration: BoxDecoration(
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          width: 2.w,
                                          color: const Color(0xFFF3F6FF),
                                        ),
                                      ),
                                      shape: BoxShape.circle,
                                      color: const Color(
                                          0xFFFF9EB7), //Color(0xFFF0DA40),
                                    ),
                                    child: Showcase.withWidget(
                                      disableMovingAnimation: true,
                                      key: _four,
                                      height: 10,
                                      width: 210,
                                      targetShapeBorder: const CircleBorder(),
                                      targetBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      container: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 10, top: 2),
                                            child: Text(
                                              "Earn on Games",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 35, top: 12),
                                                  child: Text(
                                                    'Earn on Games',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  height: 1.5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.492,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '• Get your hands on Free',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            '  Games and Let the Fun',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            '  Begin!',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .dismiss();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: const Text(
                                                                'Skip',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff3D3FB4),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 40),
                                                          InkWell(
                                                            onTap: () {
                                                              ShowCaseWidget.of(
                                                                      context)
                                                                  .dismiss();
                                                            },
                                                            child: Container(
                                                              height: 20,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xff3D3FB4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Next',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      child: Image.asset(
                                        "assets/images/earn_on_games_image.png",
                                        // fit: BoxFit.fill,
                                        width: 42.w,
                                        height: 42.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Opacity(
                                    opacity: 0.90,
                                    child: Text(
                                      AppLocale.freeGames.getString(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 9.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.84,
                                      ),
                                    ),
                                  ),
                                  // Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // height: 300,
            //   color: Color(0xFF3D3FB5),
          ),
          SizedBox(height: 10.h),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 21, right: 21, bottom: 5),
                child: InkWell(
                  onTap: _launchURLWhatsApp,
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        color: const Color(0xFF32A951),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xff000000))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.joinOurWhatsappChannelNow
                              .getString(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            height: 1.84,
                          ),
                        ),
                        const SizedBox(width: 3),
                        SizedBox(
                          height: 17,
                          child: Image.asset('assets/images/whatsapp.png'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21, bottom: 5),
            child: InkWell(
              onTap: () {
                //_launchURLYoutube();
                if (tutorialLink.isNotEmpty) {
                  _launchURLYoutube(tutorialLink);
                } else {
                  debugPrint('Tutorial link is empty');
                }
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xffED3E55))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocale.watchAppTutorial.getString(context),
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        height: 1.84,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 25,
                      child: Image.asset('assets/images/play.png'),
                    )
                  ],
                ),
              ),
            ),
          ),
          // TextButton(onPressed: (){
          //   Get.toNamed(Routes.HomeScreenNewOne);
          // }, child: Text('Add')),
          const SizedBox(height: 7),
          buildSegmentedControl(context),
          SizedBox(height: 25.h),
          // if (isLoading)
          //   Center(
          //     child: CircularProgressIndicator(
          //       strokeWidth: 1,
          //     ),
          //   ),
          // BannerAdWidget(),
          if (_selectedIndex == 0) buildAllOffers(allOffers, true),
          if (_selectedIndex == 1) buildAllOffers(myOffers, true),
          if (_selectedIndex == 2) buildAllOffers(upcomingOffers, false),
          buildBanners(),
        ],
      ),
    ));
  }

  Container buildSegmentedControl(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.fromBorderSide(
            BorderSide(width: 2, color: Colors.white.withOpacity(0.4)),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 0))
          ]),
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: CupertinoColors.white,
        thumbColor: Colors.red,
        // padding: EdgeInsets.all(8),
        groupValue: groupValue,
        children: {
          0: buildSegment(0, AppLocale.allOffers.getString(context)),
          1: buildSegment(1, AppLocale.myOffers.getString(context)),
          2: buildSegment(2, AppLocale.upComing.getString(context)),
        },
        onValueChanged: (value) {
          setState(() {
            start = 1;
            groupValue = value!;
            _selectedIndex = value;
            print(value);
            if (_selectedIndex == 0) {
              loadData();
            } else if (_selectedIndex == 1) {
              loadMyOffersData();
            } else if (_selectedIndex == 2) {
              loadUpcomingOffers();
            }
          });
        },
      ),
    );
  }

  Widget buildSegment(int index, String text) {
    return Container(
      // padding: EdgeInsets.all(8),
      height: 35.h,
      child: Center(
        child: Text(
          text,
          style: _selectedIndex == index
              ? TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  // fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.84,
                )
              : TextStyle(
                  color: Colors.black,
                  fontSize: 9.sp,
                  // fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  height: 1.84,
                ),
          // TextStyle(
          //   color: _selectedIndex == index ? Colors.white : Colors.black,
          //   fontSize: _selectedIndex == index ? 14 : 12,
          // ),
        ),
      ),
    );
  }

  // Widget buildSegmentButtons() {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //         color: AppColors.whiteColor,
  //         border: Border.fromBorderSide(
  //           BorderSide(width: 2, color: Colors.white.withOpacity(0.4)),
  //         ),
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           const BoxShadow(
  //               color: Colors.black12, blurRadius: 4, offset: Offset(0, 0))
  //         ]),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         buildSegmentedButton(0, "All Offers"),
  //         buildSegmentedButton(1, "My Offers"),
  //         buildSegmentedButton(2, "Upcoming"),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildSegmentedButton(int index, String name) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _selectedIndex = index;
  //       });
  //     },
  //     child: AnimatedContainer(
  //       decoration: BoxDecoration(
  //           color: _selectedIndex == index ? Colors.indigo : Colors.white,
  //           borderRadius: BorderRadius.circular(10)),
  //       padding: const EdgeInsets.all(12),
  //       duration: const Duration(milliseconds: 300),
  //       child: Text(
  //         name,
  //         style: TextStyle(
  //           color: _selectedIndex == index ? Colors.white : Colors.black,
  //           fontSize: _selectedIndex == index ? 14 : 12,
  //         ),
  //       ),
  //     ),
  //   );
  // }

// banner details
  Widget buildBanners() {
    return Container(
      // padding: EdgeInsets.all(10),
      height: 133.h,
      child: PageView.builder(
        controller: PageController(initialPage: 0, viewportFraction: 0.9),
        itemCount: banners.length,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var user = prefs.getString("user"); // No need to await here
                  if (user != null) {
                    UserData data = UserData.fromJson(jsonDecode(user));

                    // Uncomment these for debugging
                    // print('this is user_id: ${data.userId}');
                    // print('this is URL FROM HOME PAGE: ${banners[index].url!}');

                    if (banners[index].url != null &&
                        banners[index].url!.isNotEmpty) {
                      if (data.userId != null) {
                        String bannerUrl = banners[index].url!;

                        // Parse the URL and update the query parameters
                        Uri url = Uri.parse(bannerUrl);
                        Map<String, String> queryParams =
                            Map.from(url.queryParameters);
                        queryParams['p1'] =
                            data.userId.toString(); // Update p1 with the userId
                        queryParams['p3'] =
                            data.gaid.toString(); // Update p1 with the userId

                        Uri updatedUrl =
                            url.replace(queryParameters: queryParams);

                        // Print the updated URL for debugging
                        print('Updated URL: ${updatedUrl.toString()}');

                        await launchUrlBrowser(
                          context,
                          data.userId,
                          url: updatedUrl.toString(),
                          earncashRestApi:
                              'earncashRestApi', // Replace with actual API key if needed
                        );
                      } else {
                        showSnackBar(context, 'User ID is null');
                      }
                    } else {
                      showSnackBar(context, 'No URL found');
                    }
                  } else {
                    showSnackBar(context, 'User data not found');
                  }

                  // launchUrlBrowser(context, banners[index].url ?? "", url: '',
                  // );print('user_url: ${launchUrlBrowser(context, banners[index].url ?? "", url: '')}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      banners[index].bannerImage ?? "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            // Center(
            //     child: Text(
            //         "${(index + 1).toString() ?? ""}/${banners.length.toString()}"))
          ],
        ),
      ),
    );
  }

  // HtmlEscape htmlEscape = const HtmlEscape();

  // Future<void> _launchUrl(String _url) async {
  //   if (!await launchUrl(Uri.parse(_url),
  //       mode: LaunchMode.externalApplication)) {
  //     // throw Exception('Could not launch $_url');
  //     showSnackBar(context, 'Could not launch $_url');
  //   }
  // }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    var current = ref.watch(offerProvider).myOfferCurrentPage;
    var last = ref.watch(offerProvider).myOfferLastPage;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    if (current < last) {
      var a = await ref.read(offerProvider).getMyOffers(
          context: context,
          ref: ref,
          pageNumber: current + 1,
          userId: data.userId);
      if (a == true) {
        var list = ref.watch(offerProvider).myOffersData;
        //Insert add placements [START]
        int count = myOffers.length;
        var tempList = <OffersData>[];
        for (int i = 0; i < list.length; i++) {
          if (i != 0 && count % 3 == 0) {
            tempList.add(OffersData(isBanner: true));
          }
          tempList.add(list[i]);
          count++;
        }
        //Insert add placements [END]
        setState(() {
          if (start == 1) {
            myOffers = tempList;
          } else {
            myOffers.addAll(tempList);
          }
        });
      }
    }

    refreshcontroller.loadComplete();
  }

  // all offers and my offers data

  Widget buildAllOffers(List<OffersData> offersData, bool clickable) {
    return (offersData.length == 0 && !isLoading)
        ? Container(
            constraints: const BoxConstraints(minHeight: 200),
            child: Center(
              child: Text(
                AppLocale.noOffersAvailable.getString(context),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  // fontFamily: 'Poppins',
                  height: 1.38,
                ),
              ),
            ),
          )
        : ListView.builder(
            // key: UniqueKey(),
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            // controller: scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (isLoading && index == offersData.length) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 5,
                ));
              }
              if (offersData[index].isBanner == true) {
                return const BannerAdWidget();
              }
              // var englishTranslation = await translator.translate(input, to: 'te');
              return InkWell(
                onTap: () {
                  if (clickable) {
                    navigateToNext(
                        context, OfferDetailsPage(data: offersData[index]));
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
                  // height: 87,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.67),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 38.33,
                        offset: Offset(2.32, 8),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: getNetworkImage(
                            offersData[index].images![0].icon.toString(),
                            width: 100.w,
                            height: 70.h),
                      ),
                      // Container(
                      //   width: 100.w,
                      //   height: 75.h,
                      //   decoration: ShapeDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(
                      //           offersData[index].images![0].image.toString()),
                      //       fit: BoxFit.cover,
                      //     ),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(6)),
                      //   ),
                      // ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // var input = "नमस्ते"; // Example input in Hindi
                                // var englishTranslation = await translator.translate(input, to: 'te');
                                // FutureBuilder<String>(
                                //   future: translateText(
                                //       offersData[index].offerTitle ?? ""),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return const CircularProgressIndicator();
                                //     } else if (snapshot.hasError) {
                                //       return const Text('');
                                //     } else {
                                //       String translatedText =
                                //           snapshot.data ?? '';
                                //
                                //       // Check if the backend title matches a specific value and adjust display text
                                //       if (offersData[index].offerTitle ==
                                //           'Lemonn') {
                                //         translatedText = 'Lemonn';
                                //       }
                                //       if (offersData[index].offerTitle ==
                                //           'Gamerji') {
                                //         translatedText = 'GamerJi';
                                //       }
                                //
                                //       List<String> words =
                                //           translatedText.split(' ');
                                //       String displayText = words.length > 2
                                //           ? '${words[0]} ${words[1]}...'
                                //           : translatedText;
                                //
                                //       return Text(
                                //         displayText,
                                //         style: const TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w600,
                                //           height: 1.38,
                                //         ),
                                //       ); // Display translated title
                                //     }
                                //   },
                                // ),
                                Text(
                                  truncateText(
                                      offersData[index].offerTitle ?? '', 2),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1.38,
                                  ),
                                ),

                                // Text(
                                //  // translateText(offersData[index].offerTitle ?? '', 'te').toString(),
                                //  // translator.translate(offersData[index].offerTitle ?? '', to: 'te').toString(),
                                //   offersData[index].offerTitle ?? "",
                                //   style: const TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.w600,
                                //     height: 1.38,
                                //   ),
                                // ),
                                Stack(
                                  clipBehavior: Clip.none,
                                  // Allow items to overflow the stack
                                  children: [
                                    Image.asset('assets/images/arrow.png'),
                                    Positioned(
                                      left: 20,
                                      top: 1.2,
                                      child: Text(
                                        "${offersData[index].offerAmount ?? ""}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: -10,
                                      // Adjust this as needed to position the coin
                                      top: 0,
                                      bottom: 0,
                                      // Adjust the top position if necessary
                                      child: Image.asset(
                                        'assets/images/tp_coin.png',
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            SizedBox(height: 5.h),
                            FutureBuilder<String>(
                              future: translateText(
                                  offersData[index].offerDesc ?? ""),
                              // Replace with your input and target language code
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text('');
                                } else {
                                  return Text(
                                    snapshot.data ?? '',
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Color(0xFF8C8C8C),
                                      fontSize: 8,
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ); // Display translated title
                                }
                              },
                            ),
                            // Text(
                            //   offersData[index].offerDesc ?? "",
                            //   maxLines: 2,
                            //   style: TextStyle(
                            //     color: Color(0xFF8C8C8C),
                            //     fontSize: 8,
                            //     // fontFamily: 'Poppins',
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 7.h,
                            // ),
                            // Text(
                            //   "₹ ${offersData[index].offerAmount ?? ""}",
                            //   style: TextStyle(
                            //     color: Color(0xFFED3E55),
                            //     fontSize: 10,
                            //     fontFamily: 'Poppins',
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // child: Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                //   child: Container(
                //     height: 87,
                //     decoration: ShapeDecoration(
                //       color: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(6.67),
                //       ),
                //       shadows: const [
                //         BoxShadow(
                //           color: Color(0x11000000),
                //           blurRadius: 38.33,
                //           offset: Offset(2.32, 8),
                //           spreadRadius: 0,
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ClipRRect(
                //             borderRadius: BorderRadius.circular(6),
                //             child: getNetworkImage(
                //               offersData[index].images![0].icon.toString(),
                //               width: 100.w,
                //               height: 75.h,
                //             ),
                //           ),
                //         ),
                //         SizedBox(width: 10.w),
                //         Expanded(
                //           flex: 2,
                //           child: Padding(
                //             padding: const EdgeInsets.only(bottom: 35),
                //             child: Text(
                //               offersData[index].offerTitle ?? "",
                //               style: const TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w600,
                //                 height: 1.38,
                //               ),
                //             ),
                //           ),
                //         ),
                //         Expanded(
                //           flex: 1,
                //           child: Stack(
                //             children: [
                //               Positioned(
                //                 top: -30,
                //                 child: Container(
                //                   height: 110,
                //                   width: 110,
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(100),
                //                       border: Border.all(color: Colors.white)),
                //                   child: ClipRRect(
                //                     borderRadius: BorderRadius.circular(100),
                //                     child: getNetworkImage(
                //                       offersData[index]
                //                           .images![0]
                //                           .icon
                //                           .toString(),
                //                       height: 110.w,
                //                       width: 110.w,
                //                       fit: BoxFit.cover,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Positioned.fill(
                //                   child: Container(
                //                       color: Colors.white.withOpacity(0.94))),
                //               // Padding(
                //               //   padding: const EdgeInsets.only(top: 20),
                //               //   child: Row(
                //               //     children: [
                //               //       Container(
                //               //         height: 23,
                //               //         width: 23,
                //               //         decoration: BoxDecoration(
                //               //           color: Colors.red,
                //               //           borderRadius: BorderRadius.circular(50),
                //               //           // border: Border.all(color: Colors.red),
                //               //         ),
                //               //         child: const Center(
                //               //           child: Text(
                //               //             'TP',
                //               //             style: TextStyle(
                //               //               color: Colors.white,
                //               //               fontSize: 14,
                //               //               fontWeight: FontWeight.w600,
                //               //             ),
                //               //           ),
                //               //         ),
                //               //       ),
                //               //       const SizedBox(width: 5),
                //               //       Text(
                //               //         "${offersData[index].offerAmount ?? ""}",
                //               //         style: const TextStyle(
                //               //             color: Color(0xFFED3E55),
                //               //             fontSize: 16,
                //               //             // fontWeight: FontWeight.w600,
                //               //             fontWeight: FontWeight.bold
                //               //         ),
                //               //       ),
                //               //     ],
                //               //   ),
                //               // ),
                //               Positioned(
                //                 bottom: 5,
                //                 right: 5,
                //                 child: Row(
                //                   children: [
                //                     Container(
                //                       height: 25,
                //                       width: 25,
                //                       decoration: BoxDecoration(
                //                         color: Colors.red,
                //                         borderRadius: BorderRadius.circular(50),
                //                         // border: Border.all(color: Colors.red),
                //                       ),
                //                       child: const Center(
                //                         child: Text(
                //                           'TP',
                //                           style: TextStyle(
                //                             color: Colors.white,
                //                             fontSize: 15,
                //                             // fontWeight: FontWeight.w600,
                //                             fontWeight: FontWeight.bold,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(width: 7),
                //                     Text(
                //                       "${offersData[index].offerAmount ?? ""}",
                //                       style: const TextStyle(
                //                           color: Color(0xFFED3E55),
                //                           fontSize: 18,
                //                           // fontWeight: FontWeight.w600,
                //                           fontWeight: FontWeight.w900,
                //                           shadows: [
                //                           Shadow(
                //                           offset: Offset(-1, -1),
                //                       color: Color(0xFFED3E55),
                //                     )]
                //                       ),
                //
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         // Positioned(
                //         //   bottom: 0,
                //         //   right: 0,
                //         //   child: Container(
                //         //     height: 23,
                //         //     width: 23,
                //         //     decoration: BoxDecoration(
                //         //       color: Colors.red,
                //         //       borderRadius: BorderRadius.circular(50),
                //         //       // border: Border.all(color: Colors.red),
                //         //     ),
                //         //     child: const Center(
                //         //       child: Text(
                //         //         'TP',
                //         //         style: TextStyle(
                //         //           color: Colors.white,
                //         //           fontSize: 14,
                //         //           fontWeight: FontWeight.w600,
                //         //         ),
                //         //       ),
                //         //     ),
                //         //   ),
                //         // ),
                //         // const SizedBox(width: 5),
                //         // Text(
                //         //   "${offersData[index].offerAmount ?? ""}",
                //         //   style: const TextStyle(
                //         //       color: Color(0xFFED3E55),
                //         //       fontSize: 16,
                //         //       // fontWeight: FontWeight.w600,
                //         //       fontWeight: FontWeight.bold
                //         //   ),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
              );
            },
            itemCount: offersData.length + (isLoading ? 1 : 0),
          );
  }

  // Widget buildAllOffers2(List<OffersData> offersData, bool clickable) {
  //   var currentPage = ref.watch(offerProvider).myOfferCurrentPage;
  //   var lastPage = ref.watch(offerProvider).myOfferLastPage;
  //   return (offersData.length == 0 && !isLoading)
  //       ? Container(
  //           constraints: const BoxConstraints(minHeight: 200),
  //           child: const Center(
  //             child: Text(
  //               "No Offers Available.",
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 12,
  //                 // fontFamily: 'Poppins',
  //                 height: 1.38,
  //               ),
  //             ),
  //           ),
  //         )
  //       : ListView.builder(
  //           // key: UniqueKey(),
  //           scrollDirection: Axis.vertical,
  //           physics: const NeverScrollableScrollPhysics(),
  //           // controller: scrollController,
  //           shrinkWrap: true,
  //           itemBuilder: (context, index) {
  //             if (isLoading && index == offersData.length) {
  //               return const Center(
  //                   child: CircularProgressIndicator(
  //                 strokeWidth: 1,
  //               ));
  //             }
  //             if (offersData[index].isBanner == true) {
  //               return const BannerAdWidget();
  //             }
  //             return InkWell(
  //               onTap: () {
  //                 if (clickable) {
  //                   navigateToNext(
  //                       context, OfferDetailsPage(data: offersData[index]));
  //                 }
  //               },
  //               child: Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //                 child: Container(
  //                   height: 87,
  //                   decoration: ShapeDecoration(
  //                     color: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(6.67),
  //                     ),
  //                     shadows: [
  //                       BoxShadow(
  //                         color: Color(0x11000000),
  //                         blurRadius: 38.33,
  //                         offset: Offset(2.32, 8),
  //                         spreadRadius: 0,
  //                       ),
  //                     ],
  //                   ),
  //                   child: Row(
  //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(6),
  //                           child: getNetworkImage(
  //                             offersData[index].images![0].icon.toString(),
  //                             width: 100.w,
  //                             height: 75.h,
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 10.w),
  //                       Expanded(
  //                         flex: 2,
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(bottom: 35),
  //                           child: Text(
  //                             offersData[index].offerTitle ?? "",
  //                             style: const TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.w600,
  //                               height: 1.38,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       // Padding(
  //                       //   padding: const EdgeInsets.only(top: 20),
  //                       //   child: Row(
  //                       //     children: [
  //                       //       Container(
  //                       //         height: 23,
  //                       //         width: 23,
  //                       //         decoration: BoxDecoration(
  //                       //           color: Colors.red,
  //                       //           borderRadius: BorderRadius.circular(50),
  //                       //           // border: Border.all(color: Colors.red),
  //                       //         ),
  //                       //         child: const Center(
  //                       //           child: Text(
  //                       //             'TP',
  //                       //             style: TextStyle(
  //                       //               color: Colors.white,
  //                       //               fontSize: 14,
  //                       //               fontWeight: FontWeight.w600,
  //                       //             ),
  //                       //           ),
  //                       //         ),
  //                       //       ),
  //                       //       const SizedBox(width: 5),
  //                       //       Text(
  //                       //         "${offersData[index].offerAmount ?? ""}",
  //                       //         style: const TextStyle(
  //                       //             color: Color(0xFFED3E55),
  //                       //             fontSize: 16,
  //                       //             // fontWeight: FontWeight.w600,
  //                       //             fontWeight: FontWeight.bold
  //                       //         ),
  //                       //       ),
  //                       //     ],
  //                       //   ),
  //                       // ),
  //                       Expanded(
  //                         flex: 1,
  //                         child: Stack(
  //                           children: [
  //                             Positioned(
  //                               top: -25,
  //                               child: Container(
  //                                 height: 110,
  //                                 width: 110,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(100),
  //                                     border: Border.all(color: Colors.white)),
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(100),
  //                                   child: getNetworkImage(
  //                                     offersData[index]
  //                                         .images![0]
  //                                         .icon
  //                                         .toString(),
  //                                     height: 110.w,
  //                                     width: 110.w,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             Positioned.fill(
  //                                 child: Container(
  //                                     color: Colors.white.withOpacity(0.95))),
  //                             // Padding(
  //                             //   padding: const EdgeInsets.only(top: 20),
  //                             //   child: Row(
  //                             //     children: [
  //                             //       Container(
  //                             //         height: 23,
  //                             //         width: 23,
  //                             //         decoration: BoxDecoration(
  //                             //           color: Colors.red,
  //                             //           borderRadius: BorderRadius.circular(50),
  //                             //           // border: Border.all(color: Colors.red),
  //                             //         ),
  //                             //         child: const Center(
  //                             //           child: Text(
  //                             //             'TP',
  //                             //             style: TextStyle(
  //                             //               color: Colors.white,
  //                             //               fontSize: 14,
  //                             //               fontWeight: FontWeight.w600,
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //       ),
  //                             //       const SizedBox(width: 5),
  //                             //       Text(
  //                             //         "${offersData[index].offerAmount ?? ""}",
  //                             //         style: const TextStyle(
  //                             //             color: Color(0xFFED3E55),
  //                             //             fontSize: 16,
  //                             //             // fontWeight: FontWeight.w600,
  //                             //             fontWeight: FontWeight.bold
  //                             //         ),
  //                             //       ),
  //                             //     ],
  //                             //   ),
  //                             // ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           itemCount: offersData.length + (isLoading ? 1 : 0),
  //         );
  // }

  List<OffersData> offersData = [];
  List<OffersData> allOffers = [];
  List<OffersData> myOffers = [];
  List<OffersData> upcomingOffers = [];
  List<BannerData> banners = [];

  Future<List<OffersData>> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      print('pageNumber 2 : $start');
      var res = await ref.read(offerProvider).getAllOffers(
            context: context,
            ref: ref,
            pageNumber: start,
            userId: data.userId.toString(),
          );
      if (res == true) {
        print('pageNumber 3 : $start');
        var list = ref.watch(offerProvider).myOffersData;
        //Insert add placements [START]
        var tempList = <OffersData>[];
        int count = allOffers.length;
        print(count);
        print('length');
        for (int i = 0; i < list.length; i++) {
          if (i != 0 && count % 3 == 0) {
            tempList.add(OffersData(isBanner: true));
          }
          tempList.add(list[i]);
          count++;
        }
        //Insert add placements [END]
        setState(() {
          // offersData = list;
          if (start == 1) {
            allOffers = tempList;
          } else {
            allOffers.addAll(tempList);
          }
        });
      }
    } catch (e) {
      setState(() {
        if (start == 1) {
          allOffers = [];
        }
      });
    }
    setState(() {
      isLoading = false;
    });
    return allOffers;
  }

  Future<void> loadMyOffersData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      print(user);
      print(data.userId.toString());
      var res = await ref.read(offerProvider).getMyOffers(
            context: context,
            ref: ref,
            pageNumber: start,
            userId: data.userId.toString(),
          );
      if (res == true) {
        var list = ref.watch(offerProvider).myOffersData;
        //Insert add placements [START]
        int count = myOffers.length;
        print(count);
        print('length');
        var tempList = <OffersData>[];
        for (int i = 0; i < list.length; i++) {
          if (i != 0 && count % 3 == 0) {
            tempList.add(OffersData(isBanner: true));
          }
          tempList.add(list[i]);
          count++;
        }
        //Insert add placements [END]
        setState(() {
          if (start == 1) {
            myOffers = tempList;
          } else {
            myOffers.addAll(tempList);
          }
        });
      }
      // Map<String, String> body = HashMap();
      // body.putIfAbsent("user_id", () => data.userId.toString());
    } catch (e) {
      setState(() {
        if (start == 1) {
          myOffers = [];
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadUpcomingOffers() async {
    try {
      setState(() {
        isLoading = true;
      });
      final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      var res = await ref.read(offerProvider).getUpcomingOffers(
            context: context,
            ref: ref,
            pageNumber: start,
            userId: data.userId.toString(),
          );
      print('debug 3');
      if (res == true) {
        print('debug 4');

        var list = ref.watch(offerProvider).myOffersData;
        //Insert add placements [START]
        int count = myOffers.length;
        print(count);
        print('length');
        var tempList = <OffersData>[];
        for (int i = 0; i < list.length; i++) {
          if (i != 0 && count % 3 == 0) {
            tempList.add(OffersData(isBanner: true));
          }
          tempList.add(list[i]);
          count++;
        }
        //Insert add placements [END]
        setState(() {
          // offersData = list;
          if (start == 1) {
            upcomingOffers = tempList;
          } else {
            upcomingOffers.addAll(tempList);
          }
        });
      }

      //Insert add placements [START]
    } catch (e) {
      setState(() {
        if (start == 1) {
          upcomingOffers = [];
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadBannersData() async {
    try {
      final client = await RestClient.getRestClient();
      var list = await client.getBanners("home");
      setState(() {
        banners = list.banner?.cast<BannerData>() ?? [];
      });
    } catch (e) {
      setState(() {
        banners = [];
      });
    }
  }
}
