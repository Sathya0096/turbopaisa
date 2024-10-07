import 'dart:collection';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offersapp/api/model/EarnGameResponses.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/web_view_screen.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_services/earn_on_games_service.dart';

class EarOnGamesPageCategory extends ConsumerStatefulWidget {
  List data;
  String category;
  EarOnGamesPageCategory({Key? key,required this.category,required this.data}) : super(key: key);

  @override
  _EarOnGamesPageCategoryState createState() => _EarOnGamesPageCategoryState(data: this.data);
}

class _EarOnGamesPageCategoryState extends ConsumerState<EarOnGamesPageCategory> {
  List data;
  _EarOnGamesPageCategoryState({Key? key,required this.data});

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Free Games",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.19,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appGradientBg,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20,20,20,20),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.category}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // mainAxisExtent: 130.h,
                              childAspectRatio: 0.8,
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            EarnOnGamesData gameData = data[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewScreen(link: gameData.url)));
                                print('aaa');
                              },
                              child: Container(
                                child: Column(
                                  //crossAxisAlignment:CrossAxisAlignment.start ,
                                  children: [
                                    getNetworkImage(
                                        gameData.image,
                                        height: 75.h,
                                        width: 100.w,
                                        fit: BoxFit.contain),

                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 8.h),
                                      child: Text(
                                        gameData.name,
                                        // maxLines: 2,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 9.sp,
                                          // fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 1.84.h,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 55,
                                      height: 18.33,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFFED3E55),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Play",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            // fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            height: 1.84,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                            // Container(
                            //   margin: EdgeInsets.all(2),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       border: Border.all(
                            //           color: Colors.black26, width: 2)),
                            //   //padding: const EdgeInsets.all(10),
                            //   child: Image.network(
                            //       "https://pub-static.fotor.com/assets/projects/pages/bd883aae7f6e44bd9e6a2277f19d1aaf/300w/design-inspiration-book--b3674f926d4046278cbd0fde97be52d5.jpg"),
                            // );
                            //   color: Colors.amber,
                            //   child: Center(child: Text('$index')),
                            // );
                          }),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/eog_among_us.png',
                      //           width: 100,
                      //           //fit: BoxFit.fill,
                      //         ),
                      //         SizedBox(
                      //           height: 14,
                      //         ),
                      //         Text("among US")
                      //       ],
                      //     ),
                      //     Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/eog_sushi_roll.png',
                      //           width: 100,
                      //           // fit: BoxFit.contain,
                      //         ),
                      //         SizedBox(
                      //           height: 14,
                      //         ),
                      //         Text("Sushi Roll 3D"),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/eog_roof_rails.png',
                      //           width: 100,
                      //           // fit: BoxFit.contain,
                      //         ),
                      //         SizedBox(
                      //           height: 14,
                      //         ),
                      //         Text("Roof Ralls")
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 16,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Column(
                      //           children: [
                      //             Image.asset(
                      //               'assets/images/eog_hit_master.png',
                      //               width: 100,
                      //               //fit: BoxFit.contain,
                      //             ),
                      //             SizedBox(
                      //               height: 14,
                      //             ),
                      //             Text("Hit Master 3D")
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //     Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/eog_stealth_master.png',
                      //           width: 100,
                      //           //fit: BoxFit.contain,
                      //         ),
                      //         SizedBox(
                      //           height: 14,
                      //         ),
                      //         Text("Stealth Master")
                      //       ],
                      //     ),
                      //     Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/eog_parchisi_club.png',
                      //           width: 100,
                      //           // fit: BoxFit.contain,
                      //         ),
                      //         SizedBox(
                      //           height: 14,
                      //         ),
                      //         Text("Parchisi Club"),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication)) {
      // throw Exception('Could not launch $_url');
      showSnackBar(context, 'Could not launch $_url');
    }
  }
}
