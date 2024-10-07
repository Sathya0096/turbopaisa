import 'dart:collection';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/splash_screen.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/apiEndpoints.dart';
import '../api/api_provider.dart';
import '../api/api_services/my_offers_service.dart';
import '../api/api_services/network_error.dart';

class OfferDetailsPage extends ConsumerStatefulWidget {
  OffersData? data;
  var id;

  OfferDetailsPage({Key? key, this.id = null, required this.data})
      : super(key: key);

  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends ConsumerState<OfferDetailsPage> {
  bool isTaskLoading = false;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  var offerDetailsProvider = ChangeNotifierProvider((ref) => OffersProvider());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  bool isShowDesc = true;
  bool isShowTAC = true;

  OffersData? offerDetails;
  var taskShow = StateProvider<List<bool>>((ref) => []);
  var loading = StateProvider((ref) => true);
  ApiStatus status = ApiStatus.Stable;

  String tutorialLinkTitle = '';

  // Future<void> _fetchDetailsTitle() async {
  //   setState(() {
  //     status = ApiStatus.Loading;
  //   });
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var user = await prefs.getString("user");
  //   var data =
  //   jsonDecode(user!); // Adjust this line based on your `UserData` class
  //
  //   var response = await ApiProvider.post(
  //     url: ApiEndPoints.getOfferDetailsById,
  //     body: {'offer_id': data['offer_id'].toString()},
  //   );
  //
  //   if (response['status'] == 200) {
  //     setState(() {
  //       status = ApiStatus.Success;
  //       var res = jsonDecode(response['body']);
  //       tutorialLinkTitle = res[0]['offer_tutorial_link'].toString();
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

  Future<void> _launchURLYoutubeTitle(String url) async {
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

  // @override
  // void initState() {
  //   ref.read(loading.notifier).state = true;
  //
  //   super.initState();
  //   ref.read(taskShow.state).state.clear();
  //   if(widget.id == null){
  //     offerDetails = widget.data;
  //     ref.read(loading.notifier).state = false;
  //   }
  //   else{
  //     getOfferDetails();
  //   }
  //   loadOfferDetails();
  // }

  @override
  void initState() {
    super.initState();
    // _fetchDetailsTitle();
    analytics.setAnalyticsCollectionEnabled(true);
    Future(() {
      if (mounted) {
        ref.read(loading.notifier).state = true;
        ref.read(taskShow.state).state.clear();

        if (widget.id == null) {
          offerDetails = widget.data;
          ref.read(loading.notifier).state = false;
        } else {
          getOfferDetails();
        }

        loadOfferDetails();
      }
    });
  }

  final translator = GoogleTranslator();

  Future<String> translateText(String inputText) async {
    // await Future.delayed(Duration(seconds: 2));
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

  getOfferDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));
    print(user);
    print(data.userId.toString());
    var res = await ref.read(offerDetailsProvider).getOfferDetailsById(
          ref: ref,
          context: context,
          id: widget.id,
          userId: data.userId.toString(),
        );
    if (res == true) {
      offerDetails = ref.watch(offerDetailsProvider).myOffersData.first;
      ref.read(loading.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _taskShow = ref.watch(taskShow);
    var _loading = ref.watch(loading);
    return SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                bottomNavigationBar: BottomAppBar(
                  color: const Color.fromRGBO(224, 234, 255, 1),
                  height: 110,
                  elevation: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 21, right: 21, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            //_launchURLYoutube();
                            if (tutorialLinkTitle.isNotEmpty) {
                              _launchURLYoutubeTitle(tutorialLinkTitle);
                            } else {
                              debugPrint('Tutorial link is empty');
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 340,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: const Color(0xffED3E55))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 25,
                                  child: Image.asset('assets/images/play.png'),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppLocale.watchOfferTutorial
                                      .getString(context),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    height: 1.84,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _launchUrl(offerDetails?.url ?? "");
                        },
                        child: Container(
                          width: 340,
                          height: 35,
                          // margin: EdgeInsets.fromLTRB(10, 2, 10, 5),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFED3E55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.67),
                            ),
                          ),
                          child: Center(
                            child: FutureBuilder<String>(
                              future: translateText(
                                  offerDetails?.offerButtonTitle ??
                                      AppLocale.clickNow.getString(context)),
                              // Replace with your input and target language code
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('');
                                } else {
                                  return Text(
                                    snapshot.data ?? '',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.33,
                                      fontWeight: FontWeight.w600,
                                      height: 1.24,
                                    ),
                                  ); // Display translated title
                                }
                              },
                            ),
                            // Text(
                            //   offerDetails?.offerButtonTitle ?? AppLocale.clickNow.getString(context),
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 13.33,
                            //     fontWeight: FontWeight.w600,
                            //     height: 1.24,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: AppColors.primaryColor,
                  title: Text(
                    // translateText(offersData[index].offerTitle ?? '', 'te').toString(),
                    // translator.translate(offersData[index].offerTitle ?? '', to: 'te').toString(),
                    offerDetails?.offerTitle ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.19,
                    ),
                  ),
                  // FutureBuilder<String>(
                  //   future: translateText(
                  //       offerDetails?.offerTitle ?? ""),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('');
                  //     } else {
                  //       String translatedText =
                  //           snapshot.data ?? '';
                  //
                  //       // Check if the backend title matches a specific value and adjust display text
                  //       if (offerDetails?.offerTitle ==
                  //           'Lemonn') {
                  //         translatedText = 'Lemonn';
                  //       }
                  //       if (offerDetails?.offerTitle ==
                  //           'Gamerji') {
                  //         translatedText = 'GamerJi';
                  //       }
                  //
                  //       List<String> words = translatedText.split(' ');
                  //       String displayText = words.length > 10
                  //           ? '${words[0]} ${words[1]}'
                  //           : translatedText;
                  //
                  //       return Text(
                  //         displayText,
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           height: 1.19,
                  //         ),
                  //       ); // Display translated title
                  //     }
                  //   },
                  // ),

                  // FutureBuilder<String>(,
                  //   future: translateText(offerDetails?.offerTitle ?? ""),
                  //   // Replace with your input and target language code
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('');
                  //     } else {
                  //
                  //       return Text(
                  //         snapshot.data ?? '',
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w600,
                  //           height: 1.19,
                  //         ),
                  //       ); // Display translated title
                  //     }
                  //   },
                  // ),

                  // Text(
                  //   offerDetails?.offerTitle ?? "",
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w600,
                  //     height: 1.19,
                  //   ),
                  // ),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: Container(
                  decoration: const BoxDecoration(
                      gradient: AppColors.appLoginGradientBg),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: Image.network(offerDetails.images![0].image.toString(),
                        //       fit: BoxFit.cover,
                        //       width: double.infinity,
                        //       height: 130.h,
                        //       errorBuilder: (context, error, stackTrace) => Image.asset(
                        //             placeHolder,
                        //             height: 130.h,
                        //           )),
                        // ),
                        if (offerDetails?.images?.isNotEmpty == true)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: getNetworkImage(
                                offerDetails!.images![0].image.toString(),
                                width: 335.w,
                                height: 130.h),
                          ),
                        // Container(
                        //   width: 335.w,
                        //   height: 130.h,
                        //   decoration: ShapeDecoration(
                        //     image: DecorationImage(
                        //       image: NetworkImage(
                        //           offerDetails!.images![0].image.toString()),
                        //       fit: BoxFit.cover,
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(6.67),
                        //     ),
                        //     shadows: [
                        //       BoxShadow(
                        //         color: Color(0x11000000),
                        //         blurRadius: 38.33,
                        //         offset: Offset(2.32, 8),
                        //         spreadRadius: 0,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // translateText(offersData[index].offerTitle ?? '', 'te').toString(),
                                    // translator.translate(offersData[index].offerTitle ?? '', to: 'te').toString(),
                                    offerDetails?.offerTitle ?? "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.38,
                                    ),
                                  ),
                                  // FutureBuilder<String>(
                                  //   future: translateText(
                                  //       offerDetails?.offerTitle ?? ""),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return CircularProgressIndicator();
                                  //     } else if (snapshot.hasError) {
                                  //       return Text('');
                                  //     } else {
                                  //       String translatedText =
                                  //           snapshot.data ?? '';
                                  //
                                  //       // Check if the backend title matches a specific value and adjust display text
                                  //       if (offerDetails?.offerTitle ==
                                  //           'Lemonn') {
                                  //         translatedText = 'Lemonn';
                                  //       }
                                  //       if (offerDetails?.offerTitle ==
                                  //           'Gamerji') {
                                  //         translatedText = 'GamerJi';
                                  //       }
                                  //
                                  //       List<String> words =
                                  //           translatedText.split(' ');
                                  //       String displayText = words.length > 10
                                  //           ? '${words[0]} ${words[1]}'
                                  //           : translatedText;
                                  //
                                  //       return Text(
                                  //         displayText,
                                  //         style: const TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 10.5,
                                  //           fontWeight: FontWeight.w600,
                                  //           height: 1.38,
                                  //         ),
                                  //       ); // Display translated title
                                  //     }
                                  //   },
                                  // ),

                                  // FutureBuilder<String>(
                                  //   future: translateText(
                                  //       offerDetails?.offerTitle ?? ""),
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
                                  //         style: const TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 18),
                                  //
                                  //       ); // Display translated title
                                  //     }
                                  //   },
                                  // ),
                                  // Text(
                                  //   offerDetails?.offerTitle ?? "",
                                  //   style: const TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 18),
                                  // ),
                                  // todo working in progress
                                  FutureBuilder<String>(
                                    future: translateText(
                                        offerDetails?.offerTagline ?? ""),
                                    // Replace with your input and target language code
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('');
                                        //Text('Sathya: ${snapshot.error}');
                                      } else {
                                        return Text(
                                          snapshot.data ?? '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 1.38,
                                          ),
                                        ); // Display translated title
                                      }
                                    },
                                  ),
                                  // Text(
                                  //   offerDetails?.offerTagline ?? "",
                                  //   // "Register",
                                  //   style: const TextStyle(
                                  //     color: Colors.black,
                                  //     fontSize: 12,
                                  //     fontWeight: FontWeight.w400,
                                  //     height: 1.38,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _launchUrl(offerDetails?.url ?? "");
                                _offersCount();
                              },
                              child: Container(
                                constraints: BoxConstraints(minWidth: 83.w),
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFED3E55),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocale.get.getString(context) +
                                        " ${offerDetails?.offerAmount}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Divider(
                          thickness: 1.h,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isShowDesc = !isShowDesc;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocale.aboutApplication
                                        .getString(context),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.38,
                                    ),
                                  ),
                                  Icon(isShowDesc == true
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up)
                                  // Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (isShowDesc)
                              FutureBuilder<String>(
                                future: translateText(
                                    offerDetails?.offerDesc ?? ""),
                                // Replace with your input and target language code
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('');
                                  } else {
                                    return Text(snapshot.data ?? '',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        )); // Display translated title
                                  }
                                },
                              ),

                            // Text(
                            //       // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum doloreLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore",
                            //       offerDetails?.offerDesc ?? "",
                            //       textAlign: TextAlign.justify,
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 10.sp,
                            //         fontWeight: FontWeight.w500,
                            //       )),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        isTaskLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 1,
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // setState(() {

                                          // task?.isShow = !(task.isShow!);
                                          // });
                                          ref
                                              .read(taskShow.state)
                                              .state[index] = !_taskShow[index];
                                          print(_taskShow);
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FutureBuilder<String>(
                                                future: translateText(AppLocale
                                                        .task
                                                        .getString(context) +
                                                    '${index + 1}/${offerDetails?.tasks?.length ?? 0}'),
                                                // Replace with your input and target language code
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text('');
                                                  } else {
                                                    return Text(
                                                      snapshot.data ?? '',
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.38,
                                                      ),
                                                    ); // Display translated title
                                                  }
                                                },
                                              ),
                                              // Text(
                                              //   AppLocale.task.getString(context) + '${index + 1}/${offerDetails?.tasks?.length ?? 0}',
                                              //   style: const TextStyle(
                                              //     color: Colors.black,
                                              //     fontSize: 12,
                                              //     fontWeight: FontWeight.w600,
                                              //     height: 1.38,
                                              //   ),
                                              // ),
                                              Icon(
                                                  // task?.isShow == true
                                                  _taskShow[index] == true
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons.keyboard_arrow_up)
                                            ],
                                          ),
                                        ),
                                      ),
                                      // if(task?.isShow == true)
                                      if (_taskShow[index] == true)
                                        ...showOrHideTask(
                                            offerDetails?.tasks![index],
                                            index !=
                                                (offerDetails?.tasks?.length ??
                                                    0)),
                                    ],
                                  );
                                },
                                // itemBuilder: (context, index) => buildTask(
                                //     index + 1,
                                //     offerDetails?.tasks?.length ?? 0,
                                //     offerDetails?.tasks![index]),
                                itemCount: offerDetails?.tasks?.length ?? 0,
                              ),
                        // buildTask(),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1.h,
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isShowTAC = !isShowTAC;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocale.termsAndConditions
                                        .getString(context),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.38,
                                    ),
                                  ),
                                  Icon(isShowTAC == true
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up)
                                  // Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (isShowTAC)
                              FutureBuilder<String>(
                                future: translateText(
                                    offerDetails?.terms_and_conditions ?? ""),
                                // Replace with your input and target language code
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('');
                                  } else {
                                    return Text(snapshot.data ?? '',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        )); // Display translated title
                                  }
                                },
                              ),

                            // Text(
                            //       // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum doloreLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore",
                            //       offerDetails?.terms_and_conditions ?? "",
                            //       textAlign: TextAlign.justify,
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 10.sp,
                            //         fontWeight: FontWeight.w500,
                            //       )),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),
                        // Divider(
                        //   thickness: 1,
                        //   indent: 1,
                        //   endIndent: 1,
                        // ),
                        // if (offerDetails?.availedusers != 0)SizedBox(
                        //   height: 20.h,
                        // ),
                        //Spacer(),
                        // if (offerDetails?.availedusers != 0)
                        //   RichText(
                        //     text: TextSpan(
                        //       text: offerDetails?.availedusers?.toString() ?? "",
                        //       style: TextStyle(
                        //         color: Color(0xFFED3E55),
                        //         fontSize: 10,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       children: <TextSpan>[
                        //         TextSpan(
                        //           text: ' Users have already participated',
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontSize: 10,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  Column buildTask(int index, int total, Tasks? task) {
    bool show = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              show = !show;
              // task?.isShow = !(task.isShow!);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocale.task.getString(context) + "(${index}/${total})",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.38,
                  ),
                ),
                Icon(
                    // task?.isShow == true
                    show == true
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up)
              ],
            ),
          ),
        ),
        // if(task?.isShow == true)
        if (show == true) ...showOrHideTask(task, index != (total)),
      ],
    );
  }

  List<Widget> showOrHideTask(Tasks? task, bool isLastItem) {
    return [
      SizedBox(
        height: 12.h,
      ),
      FutureBuilder<String>(
        future: translateText(
          task?.taskName ?? "",
        ),
        // Replace with your input and target language code
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('');
          } else {
            return Text(
              snapshot.data ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ); // Display translated title
          }
        },
      ),
      // Text(
      //   // "Install Now ",
      //   task?.taskName ?? "",
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 12.sp,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
      SizedBox(
        height: 10.h,
      ),
      FutureBuilder<String>(
        future: translateText(task?.description ?? ""),
        // Replace with your input and target language code
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('');
          } else {
            return Text(
              snapshot.data ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ); // Display translated title
          }
        },
      ),

      // Text(
      //   // "Install the app in your smartphone",
      //   task?.description ?? "",
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 10.sp,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      if (isLastItem) const Divider(),
    ];
  }

  HtmlEscape htmlEscape = const HtmlEscape();

  Future<void> _launchUrl(String _url) async {
    print(_url);
    if (!await launchUrl(
        Uri.parse(
          _url,
        ),
        mode: LaunchMode.externalApplication)) {
      // throw Exception('Could not launch $_url');
      showSnackBar(context, 'Could not launch $_url');
    }
  }

  Future<void> loadOfferDetails() async {
    //getOfferDetailsById
    try {
      setState(() {
        isTaskLoading = true;
      });
      final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      Map<String, String> body = HashMap();
      body.putIfAbsent("offer_id", () => offerDetails?.offerId ?? "");

      body.putIfAbsent("user_id", () => data.userId ?? "");
      print(body);
      // List<OffersData> response = await client.getOfferDetailsById(body);

      var response = await ApiProvider.post(
          url: ApiEndPoints.getOfferDetailsById, body: body);
      print(response);

      if (response['status'] == 200) {
        List res = response['body'];

        print(res);
        print('done');
        List<OffersData> offerData = [];
        List<OffersData> data = [];
        res.forEach((element) {
          offerData.add(OffersData.fromJson(element));
        });
        res.forEach((element) {
          data.add(
            OffersData.fromJson(element),
          );
          if (offerData.isNotEmpty) {
            setState(() {
              offerDetails = offerData.first;
              // Set the offerTutorialLink here
              tutorialLinkTitle = offerDetails?.offerTutorialLink ?? "";
            });

            // Print the tasks and update the task show state
            offerData.first.tasks?.forEach((e) {
              ref.read(taskShow.state).state.add(true);
            });
            print(ref.watch(taskShow));
          }
        });
        // print(response.first.tasks);
        data.first.tasks?.forEach((e) {
          // e.isShow = true;
          ref.read(taskShow.state).state.add(true);
        });
        print(ref.watch(taskShow));
        if (data.isNotEmpty) {
          setState(() {
            offerDetails = data.first;
          });
        }
      } else if (response['status'] == 'No Connection') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NetworkError()));
      } else {}
    } catch (e) {}
    setState(() {
      isTaskLoading = false;
    });
  }

  void _offersCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));

      await FirebaseAnalytics.instance.logEvent(
        name: 'offer_clicked',
        parameters: {
          'offer_id': offerDetails?.offerId ?? '',
          'offer_title': offerDetails?.offerTitle ?? '',
          'user_id': data.userId ?? '', // Actual user ID
        },
      );
      print('Analytics event logged');
    } catch (e) {
      print('Failed to log analytics event: $e');
    }
  }
}


