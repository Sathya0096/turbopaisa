import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/api/model/ScratchCardResponse.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/apiEndpoints.dart';
import '../api/api_provider.dart';
import '../api/api_services/network_error.dart';

class ScratchCardDetailsPage extends ConsumerStatefulWidget {
  ScratchCards data;
  ScratchCardDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  _ScratchCardDetailsPageState createState() => _ScratchCardDetailsPageState();
}

class _ScratchCardDetailsPageState extends ConsumerState<ScratchCardDetailsPage> {

  bool isTaskLoading = false;
  bool isShowDesc = true;
  ScratchCards? offerDetails;
  var taskShow = StateProvider<List<bool>>((ref) => []);

  @override
  void initState() {
    super.initState();
    ref.read(taskShow.state).state.clear();
    offerDetails = widget.data;
    // loadOfferDetails();
  }
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
  String getDesc() {
    if(widget.data.scratchColor == 'Blue'){
      return widget.data.blueDesc ?? "";
    }else if(widget.data.scratchColor == 'Yellow'){
      return widget.data.yellowDesc ?? "";
    }else{
      return widget.data.orangeDesc ?? "";
    }
    //   print(widget.data.blueDesc);
    // if (widget.data.type == "Cashback") {
    //   return widget.data.yellowDesc ?? "";
    // } else if (widget.data.blueDesc!.isNotEmpty) {
    //   return widget.data.blueDesc ?? "";
    // }
    // return widget.data.orangeDesc ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var _taskShow = ref.watch(taskShow);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            title:
            FutureBuilder<String>(
              future: translateText(
                  offerDetails?.offerTitle ?? ""),
              // Replace with your input and target language code
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('');
                    //Text('');
                } else {
                  return Text(
                    snapshot.data ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.19,
                    ),
                  ); // Display translated title
                }
              },
            ),

            // Text(
            //   offerDetails?.offerTitle ?? "",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //     height: 1.19,
            //   ),
            // ),
            centerTitle: true,
            leading: IconButton(onPressed: (){
              Get.back();
            },icon: Icon(Icons.arrow_back,color: AppColors.whiteColor,),),
          ),
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.appLoginGradientBg),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
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
                  if (offerDetails?.scratchImage?.isNotEmpty == true)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: getNetworkImage(
                          offerDetails!.scratchImage!.toString(),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: translateText(
                                offerDetails?.scratchTitle ?? ""),
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ); // Display translated title
                              }
                            },
                          ),
                          // Text(
                          //   offerDetails?.scratchTitle ?? "",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 18),
                          // ),
                          // Text(
                          //   offerDetails?.sc ?? "",
                          //   // "Register",
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     height: 1.38,
                          //   ),
                          // )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          _launchUrl(offerDetails?.url ?? "");
                        },
                        child: Container(
                          constraints: BoxConstraints(minWidth: 83.w),
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFED3E55),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Center(
                            child:
                            FutureBuilder<String>(
                              future: translateText(
                                  AppLocale.get.getString(context) + " ${offerDetails?.scratchAmount}"),
                              // Replace with your input and target language code
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('');
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.38,
                                      ),
                                    ),
                                  ); // Display translated title
                                }
                              },
                            ),

                            // Text(
                            //   AppLocale.get.getString(context) + "${offerDetails?.scratchAmount}",
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 12.sp,
                            //     fontWeight: FontWeight.w600,
                            //     height: 1.38,
                            //   ),
                            // ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocale.details.getString(context),
                              style:
                              const TextStyle(
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
                     // if (isShowDesc)

                        FutureBuilder<String>(
                          future: translateText(
                            getDesc(), // Pass the text to be translated
                            // Source language code// Target language code
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('');
                            } else {
                              return Text(
                                snapshot.data ?? '',
                                semanticsLabel: getDesc(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ); // Display translated description
                            }
                          },
                        ),

                      // if (isShowDesc)
                      //
                      //   Text(
                      //     // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum doloreLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore",
                      //       getDesc(),
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
                  Divider(
                    thickness: 1,
                    indent: 1,
                    endIndent: 1,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                //   isTaskLoading
                //     ? CircularProgressIndicator(
                //   strokeWidth: 1,
                // )
                //     : ListView.builder(
                //       shrinkWrap: true,
                //       physics: NeverScrollableScrollPhysics(),
                //       itemBuilder:(context,index){
                //         return Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             InkWell(
                //               onTap: () {
                //                 // setState(() {
                //                 // task?.isShow = !(task.isShow!);
                //                 // });
                //                 ref.read(taskShow.state).state[index] = !_taskShow[index];
                //                 print(_taskShow);
                //                 setState(() {});
                //               },
                //               child: Padding(
                //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Text(
                //                       "Task (${index+1}/${offerDetails?.tasks?.length ?? 0})",
                //                       style: TextStyle(
                //                         color: Colors.black,
                //                         fontSize: 12,
                //                         fontWeight: FontWeight.w600,
                //                         height: 1.38,
                //                       ),
                //                     ),
                //                     Icon(
                //                     // task?.isShow == true
                //                       _taskShow[index] == true
                //                         ? Icons.keyboard_arrow_down
                //                         : Icons.keyboard_arrow_up,
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //             // if(task?.isShow == true)
                //             if(_taskShow[index] == true)...showOrHideTask(offerDetails?.tasks![index], index != (offerDetails?.tasks?.length ?? 0)),
                //           ],
                //         );
                //       },
                //
                //       itemCount: offerDetails?.tasks?.length ?? 0,
                //     ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      _launchUrl(offerDetails?.url ?? "");
                    },
                    child: Container(
                      width: 250,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Color(0xFFED3E55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.67),
                        ),
                      ),
                      child: Center(
                        child:
                        FutureBuilder<String>(
                          future: translateText(
                              offerDetails!.scratchButtonTitle ?? AppLocale.claimNow.getString(context)),
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
                                style: TextStyle(
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
                        //   offerDetails!.scratchButtonTitle ?? 'Claim Now',
                        //   style: TextStyle(
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
          ),
        ));
  }

  List<Widget> showOrHideTask(Tasks? task, bool isLastItem) {
    return [
      SizedBox(
        height: 12.h,
      ),

      FutureBuilder<String>(
        future: translateText(
          task?.taskName ?? "",),
        // Replace with your input and target language code
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('');
            //Text('');
          } else {
            return Text(
              snapshot.data ?? '',
              textAlign: TextAlign.center,
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
      // Text(
      //   // "Install the app in your smartphone",
      //   task?.description ?? "",
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 10.sp,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      if (isLastItem) Divider(),
    ];
  }

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

  // Future<void> loadOfferDetails() async {
  //   //getOfferDetailsById
  //   print('aaa');
  //   try {
  //     setState(() {
  //       isTaskLoading = true;
  //     });
  //     final client = await RestClient.getRestClient();
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var user = await prefs.getString("user");
  //     UserData data = UserData.fromJson(jsonDecode(user!));
  //     Map<String, String> body = HashMap();
  //     body.putIfAbsent("offer_id", () => offerDetails?.offerId ?? "");
  //     body.putIfAbsent("user_id", () => data.userId ?? "");
  //     print(body);
  //     // List<OffersData> response = await client.getOfferDetailsById(body);
  //
  //     var response = await ApiProvider.post(url:ApiEndPoints.getOfferDetailsById, body: body);
  //     print(response);
  //
  //     if (response['status'] == 200) {
  //
  //       List res = response['body'];
  //
  //       print(res);
  //       print('done');
  //       List<OffersData> data = [];
  //       res.forEach((element) {
  //         data.add(
  //           OffersData.fromJson(element),
  //         );
  //       });
  //       // print(response.first.tasks);
  //       data.first.tasks?.forEach((e) {
  //         // e.isShow = true;
  //         ref.read(taskShow.state).state.add(true);
  //       });
  //       print(ref.watch(taskShow));
  //       if (data.isNotEmpty) {
  //         setState(() {
  //           offerDetails = data.first;
  //         });
  //       }
  //
  //     } else if (response['status'] == 'No Connection') {
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>NetworkError()));
  //
  //     } else {
  //
  //     }
  //
  //
  //
  //   } catch (e) {}
  //   setState(() {
  //     isTaskLoading = false;
  //   });
  // }
}
