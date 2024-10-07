import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offersapp/api/model/WalletResponse.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/LoginPage.dart';
import 'package:offersapp/pages/add_bank_details.dart';
import 'package:offersapp/pages/change_password.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/privacy_policy.dart';
import 'package:offersapp/pages/splash_screen.dart';
import 'package:offersapp/pages/terms_and_condtions.dart';
import 'package:offersapp/pages/wallet_page.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_services/wallet_service.dart';
import '../api/model/UserData.dart';
import '../generated/assets.dart';
import 'HomePage.dart';
import 'language_Screen.dart';
import 'localization_language.dart';

class ProfileSettingsPage extends ConsumerStatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override

  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  @override
  void initState() {
    super.initState();
    loadProfile();
    loadWallet();
    _loadSelectedLanguage();
  }


  String _selectedOption = 'English';
  final FlutterLocalization _localization = FlutterLocalization.instance;
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

  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedOption = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  void _showRadioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Choose your lanugage'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _selectedOption = 'English';
                  _localization.translate('en');
                  _saveSelectedLanguage('English');
                });
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'English',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value.toString();
                        _localization.translate('en');
                        _saveSelectedLanguage('English');
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Text('English'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _selectedOption = 'Hindi';
                  _localization.translate('HDI');
                  _saveSelectedLanguage('Hindi');
                });
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'Hindi',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value.toString();
                        _localization.translate('HDI');
                        _saveSelectedLanguage('Hindi');
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Text('Hindi'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _selectedOption = 'Telugu';
                  _localization.translate('TEL');
                  // _localization.currentLocale;
                  // print('THIS IS LLANGUAG${_localization.currentLocale}');
                  _saveSelectedLanguage('Telugu');
                });
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'Telugu',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value.toString();
                        _localization.translate('TEL');
                        _saveSelectedLanguage('Telugu');
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Text('Telugu'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool isLoading = false;
  int start = 1;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());

  WalletResponse? walletResponse;

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

  UserData? userData;

  Future<void> loadProfile() async {
    try {
      print("loadProfile: called");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      setState(() {
        userData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      // fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.38,
    );

    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.all(10),
        // height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: AppColors.appGradientBg,
        ),

        //color: Colors.lightBlueAccent.withOpacity(0.2),
        // padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // SizedBox(
          //   height: 20,
          // ),
          Stack(
            children: [
              ClipPath(
                clipper: GreenClipper(),
                child: Container(
                  height: 150.h,
                  color: const Color(0xff3D3FB5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ClipRRect(
                    //   child: Image.asset(
                    //     'assets/images/proflie_image.png',
                    //     fit: BoxFit.cover,
                    //     width: 45,
                    //     // height: 200,
                    //     //height: 100,
                    //   ),
                    // ),
                    const SizedBox(
                      width: 80,
                    ),
                    Text(
                      AppLocale.myProfile.getString(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        // fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.19,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const WalletBalacePage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          // margin: EdgeInsets.all(5),2
                          color: AppColors.primaryDarkColor.withOpacity(0.5),
                        ),
                        // padding: EdgeInsets.all(20),
                        padding: const EdgeInsets.only(right: 10),
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
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child:
                                      Image.asset('assets/images/tp_coin.png'),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.00"}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 68,
                    ),
                    ClipRRect(
                      child: Image.asset(
                        'assets/images/profile_avatar.png',
                        width: 88.w,
                        // height: 200,
                        //height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // FutureBuilder<String>(
                    //   future: translateText(
                    //     userData?.name?.toUpperCase() ?? "",
                    //   ),
                    //   // Replace with your input and target language code
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return Text('');
                    //     } else {
                    //       return Text(
                    //         snapshot.data ?? '',
                    //         style:  TextStyle(
                    //           color: Colors.black,
                    //           fontSize: 16.sp,
                    //           // fontFamily: 'Poppins',
                    //           fontWeight: FontWeight.w600,
                    //           height: 1.04,
                    //         ),
                    //       ); // Display translated title
                    //     }
                    //   },
                    // ),

                    Text(

                      userData?.name?.toUpperCase() ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        // fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.04,
                      ),
                    ),
                    Text(userData?.email ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          // fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.66,
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(children: [
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(
              //         left: 20,
              //       ),
              //       child: Image.asset(
              //         'assets/images/language_icon.png',
              //         //width: 20,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 20,
              //     ),
              //     Text(
              //       "Language",
              //       style: TextStyle(fontWeight: FontWeight.w600),
              //     ),
              //     Spacer(),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 10),
              //       child: Text(
              //         "ENG",
              //         style: TextStyle(fontSize: 16),
              //       ),
              //     )
              //   ],
              // ),
              // Divider(
              //   //width: 5,
              //   color: Colors.black12,
              //   thickness: 1,
              //   height: 30,
              //   indent: 10.0,
              //   endIndent: 10.0,
              // ),
              // InkWell(
              //   onTap: () {
              //     navigateToNext(context, ChangePasswordPage());
              //   },
              //   child: Row(
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.only(left: 20.w),
              //         child: Icon(
              //           Icons.lock,
              //           size: 20.w,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 20.sp,
              //       ),
              //       Text(
              //         "Update Password",
              //         style: textStyle,
              //       )
              //     ],
              //   ),
              // ),
              // Divider(
              //   //width: 5,
              //   color: Colors.black12,
              //   thickness: 1,
              //   height: 30.h,
              //   indent: 10.0,
              //   endIndent: 10.0,
              // ),
              InkWell(
                onTap: () {
                  navigateToNext(context, const AddBankDetailsPage());
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Icon(
                        Icons.security,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      AppLocale.paymentDetails.getString(context),
                      style: textStyle,
                    )
                  ],
                ),
              ),
              Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30.h,
                indent: 10.0,
                endIndent: 10.0,
              ),
              InkWell(
                onTap: () {
                  _showRadioDialog();
                  // navigateToNext(context, const AddBankDetailsPage());
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Image.asset('assets/images/language.png'),
                      // Icon(
                      //   Icons.language,
                      //   size: 20.w,
                      // ),
                    ),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      AppLocale.chooseLanguage.getString(context),
                      //"Choose Language",
                      style: textStyle,
                    )
                  ],
                ),
              ),
              Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30.h,
                indent: 10.0,
                endIndent: 10.0,
              ),

              InkWell(
                onTap: () {
                  showSnackBar(context, "App is not available in Store.");
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Image.asset(
                        'assets/images/rate_us_icon.png',
                        //width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      AppLocale.rateUs.getString(context),
                      style: textStyle,
                    )
                  ],
                ),
              ),
              Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30.h,
                indent: 10.0,
                endIndent: 10.0,
              ),

              InkWell(
                onTap: () {
                  showSnackBar(context, AppLocale.comingSoon.getString(context));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Image.asset(
                        'assets/images/support_icon.png',
                        //width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      AppLocale.support.getString(context),
                      style: textStyle,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Image.asset(
                        'assets/images/up_arrow.png',
                        //width: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30.h,
                indent: 10.0,
                endIndent: 10.0,
              ),
              InkWell(
                onTap: () {
                  navigateToNext(context, const PrivacyPolicyPage());
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Image.asset(
                        'assets/images/privacy_policy.png',
                        // width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      AppLocale.privacyPolicy.getString(context),
                      style: textStyle,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: const Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ],
                ),
              ),
              Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30.h,
                indent: 10.0,
                endIndent: 10.0,
              ),
              InkWell(
                onTap: () {
                  navigateToNext(context, const TermsAndConditionsPage());
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/terms_conditions.png',
                        //width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Text(
                      AppLocale.termsAndConditions.getString(context),
                      style: textStyle,
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ],
                ),
              ),

              const Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30,
                indent: 10.0,
                endIndent: 10.0,
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove("user");
                  // navigateToNextReplace(context, const LoginPage());
                  navigateToNextReplace(context, const LanguageIntro());
                  await logLogoutEvent();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/log_out_icon.png',
                      ),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Text(
                      AppLocale.logout.getString(context),
                      style: textStyle,
                    )
                  ],
                ),
              ),
              const Divider(
                //width: 5,
                color: Colors.black12,
                thickness: 1,
                height: 30,
                indent: 10.0,
                endIndent: 10.0,
              ),
              SizedBox(
                height: 35.h,
              ),
              Text(
                AppLocale.followUs.getString(context),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _launchUrl(context, "http://www.facebook.com");
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Image.asset(
                          'assets/images/facebook_logo.png',
                          fit: BoxFit.cover,
                          width: 30,
                          //height: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _launchUrl(context, "http://www.instagram.com");
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Image.asset(
                          'assets/images/instagram_logo.png',
                          fit: BoxFit.cover,
                          width: 26,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _launchUrl(context, "http://www.youtube.com");
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: Image.asset(
                          'assets/images/youtube_logo.png',
                          fit: BoxFit.cover,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // buildRow(Icons.language, "Languages"),
              // Divider(),
              //         buildRow(Icons.edit, "Edit Profile"),
              //         Divider(),
              //         buildRow(Icons.star_rate, "Rate Us"),
              //         Divider(),
              //         buildRow(Icons.support_agent, "Support"),
              //         Divider(),
              //         buildRow(Icons.privacy_tip, "Privacy Policy"),
              //         Divider(),
              //         buildRow(Icons.document_scanner, "Terms and Conditions"),
              //         Divider(),
              //         InkWell(
              //             onTap: () {
              //               logout();
              //             },
              //             child: buildRow(Icons.logout, "Logout")),
              //         Divider(),
              //         Spacer(),
              //         Padding(
              //           padding: const EdgeInsets.all(16.0),
              //           child: Center(child: Text("Version: 1.0.0")),
              //         )
              //       ],
              //     ),
              //   );
              // }
              //
              // Widget buildRow(IconData data, String title) {
              //   return Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Icon(
              //           data,
              //           color: Colors.blue,
              //         ),
              //         SizedBox(
              //           width: 16,
              //         ),
              //         Text(title),
              //         Spacer(),
              //         Icon(
              //           Icons.arrow_forward_ios_rounded,
              //           size: 16,
              //           color: Colors.blue,
              //         ),
              //       ],
              //     ),
              //   );
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      // throw Exception('Could not launch $_url');
      showSnackBar(context, 'Could not launch $_url');
    }
  }
}

// DateTime? loginTime;
//
// Future<void> logLogoutEvent() async {
//   if (loginTime != null) {
//     DateTime logoutTime = DateTime.now();
//     int duration = logoutTime.difference(loginTime!).inMilliseconds;
//     await ProfileSettingsPage.analytics.logEvent(
//       name: 'logout',
//     );
//     await ProfileSettingsPage.analytics.logEvent(
//       name: 'session_duration',
//       parameters: {'duration': duration},
//     );
//   } else {
//     print('Error: loginTime is null.');
//   }
// }

DateTime? loginTime;

Future<void> logLogoutEvent() async {
  loginTime = DateTime.now();
  await LoginPage.analytics.logEvent(
    name: 'log_out',
    parameters: {'name': 'logout'},
  );
}
