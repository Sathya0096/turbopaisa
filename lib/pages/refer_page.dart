import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:offersapp/api/api_services/getReferralAmountService.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/model/WalletResponse.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/wallet_page.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_services/wallet_service.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import 'localization_language.dart';

class ReferPage extends ConsumerStatefulWidget {
  const ReferPage({Key? key}) : super(key: key);

  @override
  _ReferPageState createState() => _ReferPageState();
}

class _ReferPageState extends ConsumerState<ReferPage> {
  var referralProvider = ChangeNotifierProvider((ref) => ReferralProvider());
  bool isLoading = false;
  int start = 1;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
  int _shareCount = 0;

  String generateRandomId() {
    const fixedChars = 'TURBOPAISA';
    final random = Random();

    // Generate two random digits
    String randomDigits = '';
    for (int i = 0; i < 2; i++) {
      randomDigits += random.nextInt(10).toString();
    }

    return fixedChars + randomDigits;
  }

  // final String baseLink = 'https://www.turbopaisa.com';
  @override
  void initState() {
    super.initState();
    loadReferalCode();
    _loadShareCount();
    _incrementShareCount();

    Future.delayed(const Duration(milliseconds: 100), () {
      ref.read(referralProvider).getDetails(
            ref: ref,
            context: context,
          );
    });
    loadWallet();
  }

  Future<void> _loadShareCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareCount = prefs.getInt('share_count') ?? 0;
    });
  }

  Future<void> insertData({
    required String link,
    required String id,
    required String location,
    required String platform,
    required DateTime time,
    required String referrer,
    required String user_id,
    required String version,
  }) async {
    CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('referrals');

    try {
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      final ip = jsonDecode(response.body)['ip'];

      // Fetch location based on IP address
      final locationResponse =
          await http.get(Uri.parse('https://ipapi.co/$ip/json/'));

      // Parse location data
      final locationData = jsonDecode(locationResponse.body);
      String location =
          '${locationData['city']}, ${locationData['region']}, ${locationData['country_name']}';

      await dataCollection.add({
        'link': link,
        'id': id,
        'location': location,
        'phone': platform,
        'time': Timestamp.fromDate(time),
        'referrer': referrer,
        'user_id': user_id,
        'version': version,
      });
      print("Data inserted successfully");
    } catch (e) {
      print("Failed to insert data: $e");
    }
  }

  Future<void> _incrementShareCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareCount++;
      prefs.setInt('share_count', _shareCount);
    });
  }

  String _shareLink(BuildContext context, String app) {
    // await _incrementShareCount();
    String link;
    switch (app) {
      // case 'WhatsApp':
      //wht
      //   link =
      //       'https://play.google.com/store/apps/details?id=com.tejkun.turbopaisa&hl=en_IN&gl=US&pli=1&&referrer=utm_source%3DWA_${_shareCount}%26utm_campaign%3D${_shareCount}%26utm_content%3DT${_shareCount}';
      //   break;
      // case 'Facebook':
      //   link =
      //       'https://play.google.com/store/apps/details?id=com.tejkun.turbopaisa&hl=en_IN&gl=US&pli=1&&referrer=utm_source%3DFB_${_shareCount}%26utm_campaign%3D${_shareCount}%26utm_content%3DT${_shareCount}';
      //   break;
      // case 'Instagram':
      //   link =
      //       'https://play.google.com/store/apps/details?id=com.tejkun.turbopaisa&hl=en_IN&gl=US&pli=1&&referrer=utm_source%3DINSTA_${_shareCount}%26utm_campaign%3D${_shareCount}%26utm_content%3DT${_shareCount}';
      //   break;
      default:
        link =
            'https://app.turbopaisa.com/services/device?referral=mobile_app&utm_source=sharing&utm_medium=sms&utm_campaign=mobile_sharing';
        // 'https://turbopaisa.page.link/start/?referral=mobile_app&utm_source=sharing&utm_medium=sms&utm_campaign=mobile_sharing';
        break;
    }
    return link;
    // Share.share(link, subject: 'Check out TurboPaisa!');
  }

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

  UserData? data;

  Future<void> loadReferalCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    setState(() {
      this.data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    var referral_amount = ref.watch(referralProvider).referralAmount;
    var status = ref.watch(referralProvider).status;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          AppLocale.referAndEarn.getString(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.19,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const WalletBalacePage()));
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
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
                    width: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: Image.asset('assets/images/tp_coin.png'),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //   gradient: AppColors.appGradientBg,
            // ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/refer_friend.png",
                    width: 231.w,
                    height: 169.h,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              AppLocale.referNowAndEarnUpTo.getString(context),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.04,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset('assets/images/tp_coin.png'),
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 5),
                        ),
                        TextSpan(
                          text: '$referral_amount',
                          style: const TextStyle(
                            color: Color(0xFFED3E55),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocale.sendAReferralLinkToYourFriend.getString(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF717171),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.66,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Text(
                          AppLocale.yourReferralId.getString(
                            context,
                          ),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          DottedBorder(
                            dashPattern: [2, 3],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            color: Colors.black,
                            strokeWidth: 0.5,
                            // radius: Radius.circular(50),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 17.h),
                                child: Text('TURBOPAISA${_shareCount}')
                                // Text(generateRandomId())
                                // Text(
                                //   "${data?.userUniqueId ?? "User id is missing"}",
                                //   textAlign: TextAlign.center,
                                //   style: const TextStyle(
                                //     color: Color(0xFF2E2E2E),
                                //     fontSize: 16,
                                //     // fontFamily: 'Poppins',
                                //     fontWeight: FontWeight.w600,
                                //     height: 1.04,
                                //   ),
                                // ),
                                ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(
                                  text:
                                      // "${data?.userUniqueId ?? "User id is missing"}",
                                      "${data?.userUniqueId ?? "User id is missing"}",
                                ),
                              );
                              HapticFeedback.mediumImpact();
                              showSnackBar(context, "Copied.");
                            },
                            child: Image.asset(
                              "assets/images/solar_copy_linear.png",
                              // fit: BoxFit.cover,
                              width: 20.w,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () async {
                      String shareLink = _shareLink(context, 'July 13 2024');
                      insertData(
                          link: shareLink,
                          // link: _shareLink(context, 'msg'),
                          id: 'TURBOPAISA$_shareCount',
                          location: '',
                          platform: data?.mobile ?? '',
                          time: DateTime.now(),
                          referrer: data?.name ?? '',
                          // user_id: 'user_123',
                          user_id: data?.userId ?? '',
                          version: '18.13.0');
                      // await Share.share(
                      //   'Try the best application to earn cash. $shareLink',
                      //   // Use the link in the share text
                      //   subject: 'Share',
                      // );
// TODO CHECK THIS
                      await FlutterShare.share(
                          title: 'Share',
                          text: 'Try the best application to earn cash.',
                          // linkUrl:
                          //     "http://turbopaisa.com/referal?code=${data?.userUniqueId ?? "User id is missing"}",
                          linkUrl: _shareLink(context, ''),

                          // "https://play.google.com/store/apps/details?id=com.tejkun.turbopaisa",
                          chooserTitle: 'Share');
                    },
                    child: Container(
                      width: 250,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFED3E55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.67),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppLocale.share.getString(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            // fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.38,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 260,
                    //   padding: EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.accentColor,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(6.0),
                    //       child: Text(
                    //         "Share",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.h, right: 30.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocale.step1.getString(context),
                              style: TextStyle(
                                color: const Color(0xFFED3E55),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                AppLocale.inviteYour.getString(context),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Row(
                          children: [
                            Text(
                              AppLocale.step2.getString(context),
                              style: TextStyle(
                                color: const Color(0xFFED3E55),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                AppLocale.yourFriendsHad.getString(context),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Row(
                          children: [
                            Text(
                              AppLocale.step3.getString(context),
                              style: TextStyle(
                                color: const Color(0xFFED3E55),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                    text: AppLocale.whenYourFriend
                                        .getString(context),
                                    children: [
                                      TextSpan(
                                          style: TextStyle(
                                            color: const Color(0xFFED3E55),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          text: ' $referral_amount '),
                                      WidgetSpan(
                                          child: Text(
                                        AppLocale.tpPoint.getString(context),
                                        style: TextStyle(
                                          color: const Color(0xFFED3E55),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                    ]),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
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
            ),
          ),
          if (status == ApiStatus.Loading || status == ApiStatus.Stable)
            Container(
                color: Colors.white70,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                )),
        ],
      ),
    );
  }
}
