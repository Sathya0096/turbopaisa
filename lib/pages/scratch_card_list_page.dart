import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offersapp/api/model/BannersResponse.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/api/model/ScratchCardResponse.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/offer_details_page.dart';
import 'package:offersapp/pages/scratch_card_details_page.dart';
import 'package:offersapp/pages/scratch_card_page.dart';
import 'package:offersapp/pages/tutorial_page.dart';
import 'package:offersapp/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_services/wallet_service.dart';
import '../api/model/WalletResponse.dart';
import '../utils/app_colors.dart';
import 'HomePage.dart';

class ScratchCardListPage extends ConsumerStatefulWidget {
  const ScratchCardListPage({Key? key}) : super(key: key);

  @override
  _ScratchCardListPageState createState() => _ScratchCardListPageState();

// State<ScratchCardListPage> createState() => _ScratchCardListPageState();
}

class _ScratchCardListPageState extends ConsumerState<ScratchCardListPage> {
  int start = 1;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
  var scrollController = ScrollController();

  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    loadScratchCards();
    loadBannersDataSpin();
    loadBannersData();
    setState(() {
      start = 1;
    });
    scrollController.addListener(pagination);
    loadWallet();
  }

  void pagination() {
    if (isLoadings) {
      return;
    }
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      setState(() {
        isLoadings = true;
        start = start + 1; //+= PAGE_SIZE;
        loadWallet();
      });
    }
  }

  final translator = GoogleTranslator();

  Future<String> translateText(String inputText) async {
    await Future.delayed(Duration(seconds: 1));
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

  bool isLoadings = false;
  WalletResponse? walletResponse;

  Future<void> loadWallet() async {
    try {
      setState(() {
        isLoadings = true;
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
      isLoadings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF3F6FF),
        // height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Stack(children: [
                  ClipPath(
                    clipper: GreenClipper(),
                    child: Container(
                      height: 170.h,
                      color: const Color(0xff3D3FB5),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        AppLocale.scratchCard.getString(context),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70.h,
                    left: 77.w,
                    right: 77.w,
                    child: Container(
                      width: 218.83.w,
                      height: 95.14.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x2D000000),
                            blurRadius: 26.16,
                            offset: Offset(6.34, 3.17),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(7.5.w),
                        child: DottedBorder(
                          // dashPattern: [5, 5],
                          radius: const Radius.circular(20),
                          borderType: BorderType.RRect,
                          dashPattern: const [1, 2],
                          color: Colors.grey,
                          strokeWidth: 1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13.w,
                              ),
                              Image.asset(
                                'assets/images/wallet_icon.png',
                                // fit: BoxFit.contain,
                                width: 30.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                // margin: EdgeInsets.all(10),
                                height: 46,
                                width: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    AppLocale.availablePoints
                                        .getString(context),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.5,
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.04,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  // available points
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(
                                            'assets/images/tp_coin.png'),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        // "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.0"}",
                                        "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.0"}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.86,
                                          // fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          height: 0.83,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 96.h,
                    right: 74.w,
                    child: Stack(children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Image.asset(
                          'assets/images/semirectangle.png',
                          width: 40,
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/white_circle.png',
                            width: 3,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ]),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      AppLocale.tpPoints.getString(context),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 140.w,
                      height: 53.h,
                      // padding:
                      //     EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: const Border.fromBorderSide(
                            BorderSide(color: Color(0xFFD6E0FF), width: 1),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${walletResponse?.taskearnings?.toStringAsFixed(2) ?? "0.0"}",

                            // "${originalCardResponse?.wallet?.toStringAsFixed(2) ?? "0.0"}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.19,
                            ),
                          ),
                          Text(
                            AppLocale.tpPointsWon.getString(context),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.84,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 1;
                          switchTabs();
                        });
                      },
                      child: Container(
                        width: 98.w,
                        height: 53.h,
                        // padding:
                        //     EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            color: index == 1
                                ? const Color(0xFFED3E55)
                                : const Color(0xFFE3EAFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocale.scratchCards.getString(context),
                              style: TextStyle(
                                color: index == 1 ? Colors.white : Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                height: 1.84,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          index = 2;
                          switchTabs();
                        });
                      },
                      child: Container(
                        width: 98.w,
                        height: 53.h,
                        // padding:
                        //     EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: index == 2
                                ? const Color(0xFFED3E55)
                                : const Color(0xFFE3EAFF),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${originalCardResponse?.scratchcardwon ?? "0"}",
                              style: TextStyle(
                                color: index == 2 ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.19,
                              ),
                            ),
                            Text(
                              AppLocale.cardsWon.getString(context),
                              style: TextStyle(
                                color: index == 2 ? Colors.white : Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                height: 1.84,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // todo this is the scratch cards

                const SizedBox(
                  height: 20,
                ),
                if (!isLoading && cards?.length == 0)
                  Container(
                    constraints: const BoxConstraints(minHeight: 200),
                    child: Center(
                        child: Text(AppLocale.noScratchcardsAvailable
                            .getString(context))),
                  ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 14.h),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cards?.length ?? 0,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20.w,
                                  mainAxisExtent: 210.h,
                                  mainAxisSpacing: 20.h),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (cards![index].scratchStatus == 2) {
                                  showSnackBar(context, AppLocale.comingSoon.getString(context));
                                }
                                if (cards![index].scratchStatus == 1) {
                                  if (cards![index].url != null &&
                                      cards![index].url!.isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ScratchCardDetailsPage(
                                                    data: cards![index])));
                                    // if (cards![index].url != null && cards![index].url!.isNotEmpty) {
                                    //   launchUrlBrowser(context, cards![index].url ?? "");
                                    // }
                                  }
                                }
                                if (cards![index].scratchStatus != 0) {
                                  return;
                                }

                                Navigator.of(context)
                                    .push(
                                      TutorialOverlay(
                                        child: ScratchCardPage(
                                          data: cards![index],
                                          banners: banners2,
                                        ),
                                      ),
                                    )
                                    .whenComplete(() => loadScratchCards());
                              },
                              // todo this is only card not popup

                              child: Container(
                                child: (cards![index].scratchStatus == 0 ||
                                        cards![index].scratchStatus == 2)
                                    ? Stack(
                                        children: [
                                          buildCard(index,
                                              cards![index].scratchStatus == 2),
                                          if (cards![index].scratchStatus == 2)
                                            Center(
                                              child: Container(
                                                color: Colors.white,
                                                width: 180.w,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  AppLocale.comingSoon.getString(context),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12.sp),
                                                ),
                                              ),
                                            )
                                        ],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Image.asset(
                                            //   "assets/images/scratch_card_cup.png",
                                            //   fit: BoxFit.contain,
                                            //   width: 120,
                                            //   height: 120,
                                            // ),
                                            getNetworkImage(
                                              cards![index].scratchImage ?? "",
                                              fit: BoxFit.contain,
                                              width: 70.w,
                                              height: 70.h,
                                            ),
                                            // Image.network(
                                            //   scratchCardResponse!
                                            //           .cards![index]
                                            //           .scratchImage ??
                                            //       "",
                                            //   width: 80.w,
                                            //   height: 80.h,
                                            // ),
                                            SizedBox(
                                              height: 6.h,
                                            ),
                                            if (cards![index].type ==
                                                "Cashback")
                                              ...buildCashback(cards![index]),
                                            if (cards![index].type ==
                                                "Vocher/Discount")
                                              ...buildClaimNow(cards![index])
                                          ],
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    // width: 336.w,
                    height: 38.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 11.h, horizontal: 17.w),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF1F4FF),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 0.25, color: Color(0xFF8BB6FF)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIndicators(const Color(0xFF32A951),
                            AppLocale.moneyReward.getString(context)),
                        buildIndicators(const Color(0xFFFA9623),
                            AppLocale.vouchers.getString(context)),
                        buildIndicators(const Color(0xFF3F87FF),
                            AppLocale.cashBack.getString(context)),
                        buildIndicators(const Color(0xFFFAE103),
                            AppLocale.discount.getString(context)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                buildBanners(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ScratchCardResponse? scratchCardResponse;
  ScratchCardResponse? originalCardResponse;
  List<ScratchCards>? cards = [];
  bool isLoading = false;
  int index = 1;

  Future<void> loadScratchCards() async {
    try {
      setState(() {
        this.originalCardResponse = null;
        isLoading = true;
      });
      final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));

      ScratchCardResponse scratchCardResponse =
          await client.getScratchcards(data.userId ?? "");
      // await client.getScratchcards("1");
      setState(() {
        this.originalCardResponse = scratchCardResponse;
        isLoading = false;
        switchTabs();
      });
      switchTabs();
    } catch (e) {
      print(e);
      setState(() {
        originalCardResponse = null;
        isLoading = false;
      });
    }
  }

  void switchTabs() {
    if (index == 1) {
      cards = originalCardResponse?.cards
              ?.where((element) =>
                  element.scratchStatus == 0 || element.scratchStatus == 2)
              .toList() ??
          [];
    } else {
      cards = originalCardResponse?.cards
              ?.where((element) =>
                  element.scratchStatus != 0 && element.scratchStatus == 1)
              .toList() ??
          [];
    }
  }

  Widget buildCard(int index, bool isComingSoon) {
    //isComingSoon ??? show dark color for card
    if (cards![index].scratchColor == "Green") {
      return Image.asset(
        'assets/images/scratch_green.png',
        color: isComingSoon ? Colors.green : null,
        colorBlendMode: isComingSoon ? BlendMode.multiply : null,
      );
    } else if (cards![index].scratchColor == "Yellow") {
      return Image.asset(
        'assets/images/scratch_yellow.png',
        color: isComingSoon ? Colors.yellow : null,
        colorBlendMode: isComingSoon ? BlendMode.multiply : null,
      );
    } else if (cards![index].scratchColor == "Orange") {
      return Image.asset(
        'assets/images/scratch_orange.png',
        color: isComingSoon ? Colors.orange.withOpacity(0.5) : null,
        colorBlendMode: isComingSoon ? BlendMode.multiply : null,
      );
    } else if (cards![index].scratchColor == "Blue") {
      return Image.asset(
        'assets/images/scratch_blue.png',
        color: isComingSoon ? Colors.blue : null,
        colorBlendMode: isComingSoon ? BlendMode.multiply : null,
      );
    }
    return const SizedBox();
  }

  String getDesc(ScratchCards cards) {
    if (cards.yellowDesc?.isEmpty == false) {
      return cards.yellowDesc ?? "";
    } else if (cards.blueDesc?.isEmpty == false) {
      return cards.blueDesc ?? "";
    }
    return cards.orangeDesc ?? "";
  }

  List<Widget> buildClaimNow(ScratchCards data) {
    return [
      FutureBuilder<String>(
        future: translateText(
            "${data.scratchAmount}"
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.19,
              ),
            ); // Display translated title
          }
        },
      ),
      // Text(
      //   "${data.scratchAmount}",
      //   style: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 20,
      //     fontFamily: 'Poppins',
      //     fontWeight: FontWeight.w600,
      //     height: 1.19,
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
          future: translateText(
             "${getDesc(data)}"
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF170F49),
                  fontSize: 8,
                  // fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  // height: 1.46,
                ),
              ); // Display translated title
            }
          },
        ),
        // Text(
        //   "${getDesc(data)}",
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     color: Color(0xFF170F49),
        //     fontSize: 8,
        //     // fontFamily: 'DM Sans',
        //     fontWeight: FontWeight.w700,
        //     // height: 1.46,
        //   ),
        // ),
      ),
      // SizedBox(
      //   height: 13.h,
      // ),
      InkWell(
        // onTap: () {
        //   if (data.url != null && data.url!.isNotEmpty) {
        //     // launchUrlBrowser(context, data.url ?? "");
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 ScratchCardDetailsPage(data: cards![index])));
        //   }
        // },
        child: Container(
          width: 132.w,
          height: 25.h,
          // padding: const EdgeInsets.symmetric(horizontal: 36.16, vertical: 20.26),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFED3E55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            shadows: const [
              BoxShadow(
                color: Color(0x3A4A3AFF),
                blurRadius: 17.08,
                offset: Offset(0, 9.69),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
            child:
            Text(
              AppLocale.claimNow.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                // fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 2,
              ),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> buildCashback(ScratchCards data) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<String>(
          future: translateText("${getDesc(data)}"),
          // Replace with your input and target language code
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('');
            } else {
              return Text(
                snapshot.data ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF170F49),
                  fontSize: 8,
                  // fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.46,
                ),
              ); // Display translated title
            }
          },
        ),
        // Text(
        //   "${getDesc(data)}",
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     color: Color(0xFF170F49),
        //     fontSize: 8,
        //     // fontFamily: 'DM Sans',
        //     fontWeight: FontWeight.w700,
        //     height: 1.46,
        //   ),
        // ),
      ),
      FutureBuilder<String>(
        future: translateText(
            "${data.scratchAmount}"
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
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.19,
              ),
            ); // Display translated title
          }
        },
      ),

      // Text(
      //   "${data.scratchAmount}",
      //   style: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 20,
      //     fontFamily: 'Poppins',
      //     fontWeight: FontWeight.w600,
      //     height: 1.19,
      //   ),
      // ),
      InkWell(
        // onTap: () {
        //   if (data.url != null && data.url!.isNotEmpty) {
        //     // launchUrlBrowser(context, data.url ?? "");
        //     Navigator.push(
        //         context,
        //         // TODO DONE
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 ScratchCardDetailsPage(data: cards![index])));
        //   }
        // },
        child: Container(
          width: 132.w,
          height: 25.h,
          // padding: const EdgeInsets.symmetric(horizontal: 36.16, vertical: 20.26),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFED3E55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            shadows: const [
              BoxShadow(
                color: Color(0x3A4A3AFF),
                blurRadius: 17.08,
                offset: Offset(0, 9.69),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
            child: Text(
              AppLocale.claimNow.getString(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                // fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                height: 2,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget buildIndicators(Color materialColor, String s) {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.94,
          decoration: ShapeDecoration(
            color: materialColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.59),
            ),
          ),
        ),
        SizedBox(
          width: 5.5.w,
        ),
        Text(
          s,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 7.17,
            // fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 1.52,
          ),
        ),
        SizedBox(
          width: 12.w,
        ),
      ],
    );
  }

  List<BannerData> banners = [];
  List<BannerData> banners2 = [];

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
                onTap: () {
                  launchUrlBrowser(context, banners[index].url ?? "", url: '', earncashRestApi: '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: getNetworkImage(
                        banners[index].bannerImage ?? "",
                      )

                      // Image.network(
                      //   banners[index].bannerImage ?? "",
                      //   fit: BoxFit.cover,
                      // ),
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

  Future<void> loadBannersData() async {
    try {
      final client = await RestClient.getRestClient();
      var list = await client.getBanners("scratchcard");
      setState(() {
        banners = list.banner?.cast<BannerData>() ?? [];
      });
    } catch (e) {}
  }

  Future<void> loadBannersDataSpin() async {
    try {
      final client = await RestClient.getRestClient();
      var list = await client.getBanners("spinwheel");
      setState(() {
        banners2 = list.banner?.cast<BannerData>() ?? [];
      });
    } catch (e) {}
  }
}
// Future<void> _launchUrl(BuildContext context, String _url) async {
//   if (!await launchUrl(Uri.parse(_url),
//       mode: LaunchMode.externalApplication)) {
//     // throw Exception('Could not launch $_url');
//     showSnackBar(context, 'Could not launch $_url');
//   }
// }
