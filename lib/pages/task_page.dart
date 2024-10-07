import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/offer_details_page.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:offersapp/widgets/banner_ad.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../api/api_services/my_offers_service.dart';
import '../api/model/BannersResponse.dart';
import '../api/restclient.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage> {
  bool isLoading = false;
  int _selectedIndex = 0;
  final FlutterLocalization _localization = FlutterLocalization.instance;

  var taskProvider = ChangeNotifierProvider((ref) => OffersProvider());

  var groupValue = 0;

  // List<OffersData> offersData = [];
  List<BannerData> banners = [];

  var scrollController = ScrollController();
  static const int PAGE_SIZE = 10;
  int start = 1;
  String truncateText(String text, int wordCount) {
    List<String> words = text.split(' ');
    if (words.length <= wordCount) {
      return text;
    } else {
      return words.take(wordCount).join(' ') + '...';
    }
  }
  @override
  void initState() {
    super.initState();
    scrollController.addListener(pagination);
    loadData();
    loadBannersData();
  }

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
          loadData();
        } else if (_selectedIndex == 1) {
          loadMyOffersData();
        } else if (_selectedIndex == 2) {
          loadUpcomingOffers();
        }
      });
    }
  }

  List<OffersData> allOffers = [];
  List<OffersData> myOffers = [];
  List<OffersData> upcomingOffers = [];

  // Future<void> loadData() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final client = await RestClient.getRestClient();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     UserData data = UserData.fromJson(jsonDecode(user!));
  //
  //     var list = await client.getOffers(data.userId ?? "");
  //     //Insert add placements [START]
  //     var tempList = <OffersData>[];
  //     for (int i = 0; i < list.length; i++) {
  //       if (i != 0 && i % 3 == 0) {
  //         tempList.add(OffersData(isBanner: true));
  //       }
  //       tempList.add(list[i]);
  //     }
  //     //Insert add placements [END]
  //     setState(() {
  //       allOffers = tempList;
  //     });
  //   } catch (e) {}
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // Future<List<OffersData>> loadData() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     UserData data = UserData.fromJson(jsonDecode(user!));
  //
  //     final client = await RestClient.getRestClient();
  //     // var list = await client.getOffers(data.userId ?? "");
  //     var list =
  //         await client.getofferDetails(data.userId ?? "", start, PAGE_SIZE);
  //     //Insert add placements [START]
  //     var tempList = <OffersData>[];
  //     int count = allOffers.length;
  //     for (int i = 0; i < list.length; i++) {
  //       if (i != 0 && count % 3 == 0) {
  //         tempList.add(OffersData(isBanner: true));
  //       }
  //       tempList.add(list[i]);
  //       count++;
  //     }
  //     //Insert add placements [END]
  //     setState(() {
  //       // offersData = list;
  //       if (start == 1) {
  //         allOffers = tempList;
  //       } else {
  //         allOffers.addAll(tempList);
  //       }
  //     });
  //   } catch (e) {
  //     setState(() {
  //       if (start == 1) {
  //         allOffers = [];
  //       }
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //   return allOffers;
  // }

  Future<List<OffersData>> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      var res = await ref.read(taskProvider).getAllOffers(
            context: context,
            ref: ref,
            pageNumber: int.parse(start.toString()),
            userId: data.userId.toString(),
          );
      if (res == true) {
        var list = ref.watch(taskProvider).myOffersData;
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

  Future<void> loadBannersData() async {
    try {
      final client = await RestClient.getRestClient();
      var list = await client.getBanners("home");
      setState(() {
        banners = list.banner?.cast<BannerData>() ?? [];
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          AppLocale.task.getString(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.19,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              buildSegmentedControl(context),
              // if (isLoading)
              //   Center(
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1,
              //     ),
              //   ),
              if (_selectedIndex == 0) buildAllOffers(allOffers, true),
              if (_selectedIndex == 1) buildAllOffers(myOffers, true),
              if (_selectedIndex == 2) buildAllOffers(upcomingOffers, false),
              buildBanners(),
            ],
          ),
        ),
      ),
    );
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
          boxShadow: [
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
  //     margin: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //         color: AppColors.whiteColor,
  //         border: Border.fromBorderSide(
  //           BorderSide(width: 2, color: Colors.white.withOpacity(0.4)),
  //         ),
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.black12, blurRadius: 4, offset: Offset(0, 0))
  //         ]),
  //     // child: Row(
  //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     //   children: [
  //     //     buildSegmentedButton(0, "ssAll Offers"),
  //     //     buildSegmentedButton(1, "My Offers"),
  //     //     buildSegmentedButton(2, "Upcoming"),
  //     //   ],
  //     // ),
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
  //       padding: EdgeInsets.all(12),
  //       duration: Duration(milliseconds: 300),
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

  Widget buildAllOffers(List<OffersData> offersData, bool clickable) {
    return (offersData.length == 0 && !isLoading)
        ? Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: Center(
        child: Text(
          AppLocale.noOffersAvailable.getString(context),
          style: TextStyle(
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
                strokeWidth: 1,
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
                          //   future: translateText(offersData[index].offerTitle ?? ""),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState == ConnectionState.waiting) {
                          //       return CircularProgressIndicator();
                          //     } else if (snapshot.hasError) {
                          //       return Text('');
                          //     } else {
                          //       String translatedText = snapshot.data ?? '';
                          //
                          //       // Check if the backend title matches a specific value and adjust display text
                          //       if (offersData[index].offerTitle == 'Lemonn') {
                          //         translatedText = 'Lemonn';
                          //       }
                          //       if (offersData[index].offerTitle == 'Gamerji') {
                          //         translatedText = 'GamerJi';
                          //       }
                          //
                          //       List<String> words = translatedText.split(' ');
                          //       String displayText = words.length > 2
                          //           ? '${words[0]} ${words[2]}...'
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
                          // Text(
                          //   translateText(offersData[index].offerTitle ?? '', 'te').toString(),
                          //   // translator.translate(offersData[index].offerTitle ?? '', to: 'te').toString(),
                          //   // offersData[index].offerTitle ?? "",
                          //   // style: const TextStyle(
                          //   //   color: Colors.black,
                          //   //   fontSize: 12,
                          //   //   fontWeight: FontWeight.w600,
                          //   //   height: 1.38,
                          //   // ),
                          // ),
                          Text(
                            truncateText(offersData[index].offerTitle ?? '', 2),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                            ),
                          ),
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
                                  style: TextStyle(
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
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('');
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

  // Widget buildAllOffers(List<OffersData> offersData, bool clickable) {
  //   return (offersData.length == 0 && !isLoading)
  //       ? Container(
  //     constraints: const BoxConstraints(minHeight: 200),
  //     child: const Center(
  //       child: Text(
  //         "No Offers Available.",
  //         style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 12,
  //           // fontFamily: 'Poppins',
  //           height: 1.38,
  //         ),
  //       ),
  //     ),
  //   )
  //       : ListView.builder(
  //     // key: UniqueKey(),
  //     scrollDirection: Axis.vertical,
  //     physics: const NeverScrollableScrollPhysics(),
  //     // controller: scrollController,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       if (isLoading && index == offersData.length) {
  //         return const Center(
  //             child: CircularProgressIndicator(
  //               strokeWidth: 1,
  //             ));
  //       }
  //       if (offersData[index].isBanner == true) {
  //         return const BannerAdWidget();
  //       }
  //       return InkWell(
  //         onTap: () {
  //           if (clickable) {
  //             navigateToNext(
  //                 context, OfferDetailsPage(data: offersData[index]));
  //           }
  //         },
  //         child: Padding(
  //           padding:
  //           const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //           child: Container(
  //             height: 87,
  //             decoration: ShapeDecoration(
  //               color: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(6.67),
  //               ),
  //               shadows: [
  //                 BoxShadow(
  //                   color: Color(0x11000000),
  //                   blurRadius: 38.33,
  //                   offset: Offset(2.32, 8),
  //                   spreadRadius: 0,
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(6),
  //                     child: getNetworkImage(
  //                       offersData[index].images![0].icon.toString(),
  //                       width: 100.w,
  //                       height: 75.h,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 10.w),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(bottom: 35),
  //                     child: Text(
  //                       offersData[index].offerTitle ?? "",
  //                       style: const TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 15,
  //                         fontWeight: FontWeight.w600,
  //                         height: 1.38,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Stack(
  //                     children: [
  //                       Positioned(
  //                         top: -30,
  //                         child: Container(
  //                           height: 110,
  //                           width: 110,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(100),
  //                               border: Border.all(color: Colors.white)),
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(100),
  //                             child: getNetworkImage(
  //                               offersData[index]
  //                                   .images![0]
  //                                   .icon
  //                                   .toString(),
  //                               height: 110.w,
  //                               width: 110.w,
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned.fill(
  //                           child: Container(
  //                               color: Colors.white.withOpacity(0.94))),
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
  //                       Positioned(
  //                         bottom: 5,
  //                         right: 5,
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               height: 25,
  //                               width: 25,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.red,
  //                                 borderRadius: BorderRadius.circular(50),
  //                                 // border: Border.all(color: Colors.red),
  //                               ),
  //                               child: const Center(
  //                                 child: Text(
  //                                   'TP',
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 15,
  //                                     // fontWeight: FontWeight.w600,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(width: 7),
  //                             Text(
  //                               "${offersData[index].offerAmount ?? ""}",
  //                               style: const TextStyle(
  //                                   color: Color(0xFFED3E55),
  //                                   fontSize: 18,
  //                                   // fontWeight: FontWeight.w600,
  //                                   fontWeight: FontWeight.w900,
  //                                   shadows: [
  //                                     Shadow(
  //                                       offset: Offset(-1, -1),
  //                                       color: Color(0xFFED3E55),
  //                                     )]
  //                               ),
  //
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 // Positioned(
  //                 //   bottom: 0,
  //                 //   right: 0,
  //                 //   child: Container(
  //                 //     height: 23,
  //                 //     width: 23,
  //                 //     decoration: BoxDecoration(
  //                 //       color: Colors.red,
  //                 //       borderRadius: BorderRadius.circular(50),
  //                 //       // border: Border.all(color: Colors.red),
  //                 //     ),
  //                 //     child: const Center(
  //                 //       child: Text(
  //                 //         'TP',
  //                 //         style: TextStyle(
  //                 //           color: Colors.white,
  //                 //           fontSize: 14,
  //                 //           fontWeight: FontWeight.w600,
  //                 //         ),
  //                 //       ),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // const SizedBox(width: 5),
  //                 // Text(
  //                 //   "${offersData[index].offerAmount ?? ""}",
  //                 //   style: const TextStyle(
  //                 //       color: Color(0xFFED3E55),
  //                 //       fontSize: 16,
  //                 //       // fontWeight: FontWeight.w600,
  //                 //       fontWeight: FontWeight.bold
  //                 //   ),
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     itemCount: offersData.length + (isLoading ? 1 : 0),
  //   );
  // }

  PageController _pageController =
      new PageController(initialPage: 0, viewportFraction: 0.8);

  Widget buildBanners() {
    return Container(
      // padding: EdgeInsets.all(10),
      height: 133.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  launchUrlBrowser(context, banners[index].url ?? "", url: '', earncashRestApi: '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      banners[index].bannerImage ?? "",
                      fit: BoxFit.cover,
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

  // Future<void> loadMyOffersData() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     UserData data = UserData.fromJson(jsonDecode(user!));
  //
  //     Map<String, String> body = HashMap();
  //     body.putIfAbsent("user_id", () => data.userId.toString());
  //
  //     final client = await RestClient.getRestClient();
  //     var list = await client.getMyOffer(body);
  //     //Insert add placements [START]
  //     var tempList = <OffersData>[];
  //     for (int i = 0; i < list.length; i++) {
  //       if (i != 0 && i % 3 == 0) {
  //         tempList.add(OffersData(isBanner: true));
  //       }
  //       tempList.add(list[i]);
  //     }
  //     //Insert add placements [END]
  //     setState(() {
  //       // offersData = list;
  //       myOffers = tempList;
  //     });
  //   } catch (e) {}
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  // Future<void> loadMyOffersData() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     UserData data = UserData.fromJson(jsonDecode(user!));
  //
  //     Map<String, String> body = HashMap();
  //     body.putIfAbsent("user_id", () => data.userId.toString());
  //
  //     final client = await RestClient.getRestClient();
  //     // var list = await client.getMyOffer(body);
  //     var list =
  //         await client.getMyOffersDetailspagination(start, PAGE_SIZE, body);
  //     //Insert add placements [START]
  //     int count = myOffers.length;
  //     var tempList = <OffersData>[];
  //     for (int i = 0; i < list.length; i++) {
  //       if (i != 0 && count % 3 == 0) {
  //         tempList.add(OffersData(isBanner: true));
  //       }
  //       tempList.add(list[i]);
  //       count++;
  //     }
  //     //Insert add placements [END]
  //     setState(() {
  //       if (start == 1) {
  //         myOffers = tempList;
  //       } else {
  //         myOffers.addAll(tempList);
  //       }
  //     });
  //   } catch (e) {
  //     setState(() {
  //       if (start == 1) {
  //         myOffers = [];
  //       }
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

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
      var res = await ref.read(taskProvider).getMyOffers(
            context: context,
            ref: ref,
            pageNumber: start,
            userId: data.userId.toString(),
          );
      if (res == true) {
        var list = ref.watch(taskProvider).myOffersData;
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
      var res = await ref.read(taskProvider).getUpcomingOffers(
            context: context,
            ref: ref,
            pageNumber: int.parse(start.toString()),
            userId: data.userId.toString(),
          );
      print('debug 3');
      if (res == true) {
        print('debug 4');

        var list = ref.watch(taskProvider).myOffersData;
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
// Future<void> loadUpcomingOffers() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });
//     final client = await RestClient.getRestClient();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var user = await prefs.getString("user");
//     UserData data = UserData.fromJson(jsonDecode(user!));
//     var list = await client.getUpComingOffers(data.userId.toString());
//
//     //Insert add placements [START]
//     var tempList = <OffersData>[];
//     for (int i = 0; i < list.length; i++) {
//       if (i != 0 && i % 3 == 0) {
//         tempList.add(OffersData(isBanner: true));
//       }
//       tempList.add(list[i]);
//     }
//     //Insert add placements [END]
//
//     setState(() {
//       // offersData = list;
//       upcomingOffers = tempList;
//     });
//   } catch (e) {}
//   setState(() {
//     isLoading = false;
//   });
// }

// Future<void> loadUpcomingOffers() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });
//     final client = await RestClient.getRestClient();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var user = await prefs.getString("user");
//     UserData data = UserData.fromJson(jsonDecode(user!));
//     var list = await client.getUpcomingofferDetails(
//         data.userId.toString(), start, PAGE_SIZE);
//     //Insert add placements [START]
//     int count = myOffers.length;
//     var tempList = <OffersData>[];
//     for (int i = 0; i < list.length; i++) {
//       if (i != 0 && count % 3 == 0) {
//         tempList.add(OffersData(isBanner: true));
//       }
//       tempList.add(list[i]);
//       count++;
//     }
//     //Insert add placements [END]
//     setState(() {
//       // offersData = list;
//       if (start == 1) {
//         upcomingOffers = tempList;
//       } else {
//         upcomingOffers.addAll(tempList);
//       }
//     });
//   } catch (e) {
//     setState(() {
//       if (start == 1) {
//         upcomingOffers = [];
//       }
//     });
//   }
//   setState(() {
//     isLoading = false;
//   });
// }
}
