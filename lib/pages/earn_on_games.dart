import 'dart:collection';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:offersapp/api/model/EarnGameResponses.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/web_view_screen.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_services/earn_on_games_service.dart';
import 'earn_on_games_2.dart';

class EarOnGamesPage extends ConsumerStatefulWidget {
  const EarOnGamesPage({Key? key}) : super(key: key);

  @override
  _EarOnGamesPageState createState() => _EarOnGamesPageState();
}

class _EarOnGamesPageState extends ConsumerState<EarOnGamesPage> {

  var earnOnGamesProvider = ChangeNotifierProvider((ref) => EarnOnGamesProvider());

  @override
  void initState() {
    super.initState();
    loadEarngame();
  }

  EarnGameResponses? earnGameResponses;
  bool isLoading = false;

  Widget build(BuildContext context) {
    var data = ref.watch(earnOnGamesProvider).gamesData;
    var status = ref.watch(earnOnGamesProvider).status;
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
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: status == ApiStatus.Loading || status == ApiStatus.Stable
      ? Center(
        child: CircularProgressIndicator(),
      )
      : SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appGradientBg,
            ),
            child: isLoading
                ? Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                )
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        Container(
                          height: 180.h,
                          child: PageView.builder(
                            controller: PageController(initialPage: 0, viewportFraction: 0.9),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  print(earnGameResponses!.banners![index].url);
                                  _launchUrl(earnGameResponses!.banners![index].url!);

                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5,right: 5),
                                  padding: EdgeInsets.only(top: 10,bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      earnGameResponses?.banners?[index].bannerImage ??
                                          "",
                                      fit: BoxFit.fill,
                                      height: 180.h,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: earnGameResponses?.banners?.length ?? 0,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 20),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Recent Played Games",
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       ),
                        //       SizedBox(
                        //         height: 14,
                        //       ),
                        //       SizedBox(
                        //         height: 120.h,
                        //         child: ListView.builder(
                        //           scrollDirection: Axis.horizontal,
                        //           itemBuilder: (context, index) {
                        //             return Padding(
                        //               padding: const EdgeInsets.only(right: 30),
                        //               child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   children: [
                        //                     InkWell(
                        //                       onTap: () {
                        //                         _launchUrl(earnGameResponses
                        //                                 ?.recentplayedgames?[index]
                        //                                 .url ??
                        //                             "");
                        //                       },
                        //                       child: getNetworkImage(
                        //                         earnGameResponses
                        //                                 ?.recentplayedgames?[index]
                        //                                 .earnGameImage ??
                        //                             "",
                        //                         height: 55.h,
                        //                         width: 55.w,
                        //                       ),
                        //                     ),
                        //                     Padding(
                        //                       padding: const EdgeInsets.symmetric(
                        //                           vertical: 8.0),
                        //                       child: Center(
                        //                         child: Text(
                        //                           earnGameResponses
                        //                                   ?.recentplayedgames?[
                        //                                       index]
                        //                                   .earnGameTitle ??
                        //                               "",
                        //                           style: TextStyle(
                        //                             color: Colors.black,
                        //                             fontSize: 9.sp,
                        //                             fontWeight: FontWeight.w600,
                        //                             height: 1.84,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     Container(
                        //                       width: 55,
                        //                       height: 18.33,
                        //                       decoration: ShapeDecoration(
                        //                         color: Color(0xFFED3E55),
                        //                         shape: RoundedRectangleBorder(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(5)),
                        //                       ),
                        //                       child: Center(
                        //                         child: Text(
                        //                           "Install",
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 9.sp,
                        //                             // fontFamily: 'Poppins',
                        //                             fontWeight: FontWeight.w600,
                        //                             height: 1.84,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     )
                        //                   ]),
                        //             );
                        //           },
                        //           itemCount: earnGameResponses
                        //                   ?.recentplayedgames?.length ??
                        //               0,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(0,0,0,20),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context,ind){
                            var categoryName = data[ind]['category'];
                            List games = data[ind]['games'];
                            return Padding(
                              padding: EdgeInsets.fromLTRB(20,20,20,0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5,0,5,0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "$categoryName",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EarOnGamesPageCategory(data: games,category: categoryName,)));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppColors.primaryColor,
                                            ),
                                            child: Text(
                                              "View all",
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10.sp),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        // mainAxisExtent: 130.h,
                                          childAspectRatio: 0.8,
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20),
                                      itemCount: games.length >= 6 ? 6 : games.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        EarnOnGamesData gameData = games[index];
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
                                                  // height: 18.33,
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
                            );
                          },
                        ),
                        // SizedBox(
                        //   height: 150,
                        //   child: PageView(
                        //     controller: PageController(viewportFraction: 0.9),
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.all(10),
                        //         child: Image.asset(
                        //           'assets/images/scratch_banner.png',
                        //           //width: 300,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.all(10),
                        //         child: Image.asset(
                        //           'assets/images/eog_banner.png',
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.all(10),
                        //         child: Image.asset(
                        //           'assets/images/scratch_banner.png',
                        //           //width: 300,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.all(10),
                        //         child: Image.asset(
                        //           'assets/images/eog_banner.png',
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                ),
          )),
    );
  }

  // void loadEarngame() async {
  //   setState(() {});
  //   try {
  //     final client = await RestClient.getRestClient();
  //     List<EarnGameResponses> data = await client.getEarngame();
  //     print(data.length);
  //     setState(() {
  //       earnGameResponses = data;
  //     });
  //   } catch (e, stacktrace) {
  //     print(stacktrace.toString());
  //   }
  // }

  Future<void> loadEarngame() async {
    setState(() {
      isLoading = true;
    });
    try {
      final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? user = prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      Map<String, String> body = HashMap();
      body.putIfAbsent("user_id", () => data.userId.toString());

      var res = await ref.read(earnOnGamesProvider).getGames(
        context: context,ref: ref,
      );
      EarnGameResponses response =
          await client.getEarngame(data.userId.toString());
      setState(() {
        earnGameResponses = response;
      });
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  HtmlEscape htmlEscape = HtmlEscape();

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication)) {
      // throw Exception('Could not launch $_url');
      showSnackBar(context, 'Could not launch $_url');
    }
  }
}
