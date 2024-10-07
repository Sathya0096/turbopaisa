// import 'dart:collection';
// import 'dart:convert';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/route_manager.dart';
// import 'package:offersapp/api/api_services/wallet_service.dart';
// import 'package:offersapp/api/model/RegistrationResponse.dart';
// import 'package:offersapp/api/model/WalletResponse.dart';
// import 'package:offersapp/api/restclient.dart';
// import 'package:offersapp/pages/dashboard_page.dart';
// import 'package:offersapp/pages/localization_language.dart';
// import 'package:offersapp/utils.dart';
// import 'package:offersapp/utils/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:translator/translator.dart';
// import '../api/model/UserData.dart';
//
// class WalletBalacePage extends ConsumerStatefulWidget {
//   const WalletBalacePage({Key? key}) : super(key: key);
//
//   @override
//   _WalletBalacePageState createState() => _WalletBalacePageState();
// }
//
// class _WalletBalacePageState extends ConsumerState<WalletBalacePage> {
//   var scrollController = ScrollController();
//
//   // static const int PAGE_SIZE = 10;
//   int start = 1;
//   var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
//   final FlutterLocalization _localization = FlutterLocalization.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       start = 1;
//     });
//     scrollController.addListener(pagination);
//     loadWallet();
//   }
//
//   final translator = GoogleTranslator();
//
//   Future<String> translateText(String inputText) async {
//     // print('THIS IS LOCAL LANG ${_localization.currentLocale}');
//     // print('this is calls ok');
//     var translation = await translator.translate(inputText,
//         to: _localization.currentLocale.toString() == 'en_US'
//             ? 'en'
//             : _localization.currentLocale.toString() == 'HDI_IN'
//                 ? 'hi'
//                 : 'te');
//     return translation.toString();
//   }
//
//   void pagination() {
//     if (isLoading) {
//       return;
//     }
//     if ((scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent)) {
//       setState(() {
//         isLoading = true;
//         start = start + 1; //+= PAGE_SIZE;
//         loadWallet();
//       });
//     }
//   }
//
//   bool isLoading = false;
//   WalletResponse? walletResponse;
//
//   Future<void> loadWallet() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       // final client = await RestClient.getRestClient();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var user = await prefs.getString("user");
//       UserData data = UserData.fromJson(jsonDecode(user!));
//
//       print(start);
//       // WalletResponse scratchCardResponse =
//       //     await client.getTransactions(data.userId ?? "", start, PAGE_SIZE);
//       var res = await ref.read(walletProvider).transactions(
//             context: context,
//             ref: ref,
//             count: '10',
//             pagenumber: start.toString(),
//             user_id: data.userId,
//           );
//       if (res == true) {
//         var data = ref.watch(walletProvider).data.first;
//         setState(() {
//           if (start == 1) {
//             walletResponse = data;
//           } else {
//             walletResponse?.transactions?.addAll(data.transactions ?? []);
//           }
//         });
//       }
//     } catch (e) {
//       print(e);
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xFFF3F6FF),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Stack(children: [
//                 ClipPath(
//                   clipper: GreenClipper(),
//                   child: Container(
//                     height: 170.h,
//                     color: const Color(0xff3D3FB5),
//                   ),
//                 ),
//                 Positioned(
//                   top: 70.h,
//                   left: 77.w,
//                   right: 77.w,
//                   child: Container(
//                     width: 218.83.w,
//                     height: 95.14.h,
//                     decoration: ShapeDecoration(
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20.w),
//                       ),
//                       shadows: [
//                         const BoxShadow(
//                           color: Color(0x2D000000),
//                           blurRadius: 26.16,
//                           offset: Offset(6.34, 3.17),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(7.5.w),
//                       child: DottedBorder(
//                         // dashPattern: [5, 5],
//                         radius: const Radius.circular(20),
//                         borderType: BorderType.RRect,
//                         dashPattern: [1, 2],
//                         color: Colors.grey,
//                         strokeWidth: 1,
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 13.w,
//                             ),
//                             Image.asset(
//                               'assets/images/wallet_icon.png',
//                               // fit: BoxFit.contain,
//                               width: 30.w,
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Container(
//                               // margin: EdgeInsets.all(10),
//                               height: 46,
//                               width: 1,
//                               color: Colors.grey.withOpacity(0.5),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: 10.h,
//                                 ),
//                                 Text(
//                                   AppLocale.availablePoints.getString(context),
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 11.5,
//                                     // fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.04,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 6.h,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       height: 24,
//                                       width: 24,
//                                       child: Image.asset(
//                                           'assets/images/tp_coin.png'),
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       "${walletResponse?.wallet?.toStringAsFixed(2) ?? "0.0"}",
//                                       style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 15.86,
//                                         // fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w700,
//                                         height: 0.83,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 96.h,
//                   right: 74.w,
//                   child: Stack(children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             bottomRight: Radius.circular(10)),
//                       ),
//                       child: Image.asset(
//                         'assets/images/semirectangle.png',
//                         width: 40,
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Image.asset(
//                           'assets/images/white_circle.png',
//                           width: 3,
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
//
//                 // IconButton(
//                 //   onPressed: (){Navigator.pop(context);},
//                 //   icon: Icon(Icons.arrow_back,color: Colors.white,),
//                 // ),
//                 IconButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     )),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Text(
//                       AppLocale.myWallet.getString(context),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.sp,
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         height: 1.19,
//                       ),
//                     ),
//                   ),
//                 ),
//               ]),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Column(
//                       children: [
//                         // SizedBox(
//                         //   height: 20,
//                         // ),
//                         InkWell(
//                           onTap: () {
//                             showWithdrawPopup();
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(top: 11.h, bottom: 8.h),
//                             width: 250.w,
//                             height: 40.h,
//                             decoration: ShapeDecoration(
//                               color: walletResponse != null &&
//                                       walletResponse!.wallet! > 0
//                                   ? const Color(0xFFED3E55)
//                                   : Colors.grey,
//                               //if waller balance is zero, grey button
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6.67),
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 AppLocale.redeemNow.getString(context),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 13.33,
//                                   // fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w600,
//                                   height: 1.24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.error_outline,
//                               color: Colors.grey,
//                               size: 16,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               AppLocale.tpPoints.getString(context),
//                               style: const TextStyle(
//                                   fontSize: 12, color: Colors.grey),
//                             )
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 25),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 // padding: EdgeInsets.symmetric(
//                                 //     vertical: 10.h, horizontal: 15.w
//                                 // ),
//                                 decoration: BoxDecoration(
//                                     color: const Color(0xFFE3EAFF),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       AppLocale.earnedPoints.getString(context),
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10.sp,
//                                         // fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w600,
//                                         height: 1.66,
//                                       ),
//                                     ),
//                                     Text(
//                                       "${walletResponse?.taskearnings?.toStringAsFixed(2) ?? "0.0"}",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 height: 65.h,
//                                 width: 149.w,
//                               ),
//                               Container(
//                                 height: 65.h,
//                                 width: 159.w,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 15),
//                                 decoration: BoxDecoration(
//                                     color: const Color(0xFFE3EAFF),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       AppLocale.redeemedPoints
//                                           .getString(context),
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 10.sp,
//                                         // fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w600,
//                                         height: 1.66,
//                                       ),
//                                     ),
//                                     Text(
//                                       "${walletResponse?.withdraw?.toStringAsFixed(2) ?? "0.0"}",
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 14.sp,
//                                         // fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w600,
//                                         height: 1.19,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 40.h,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               AppLocale.recentTransactions.getString(context),
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12.sp,
//                                 // fontFamily: 'Poppins',
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.45,
//                               ),
//                             ),
//                             // Text("Value"),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 26.h,
//                         ),
//                         //Divider(),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             if (isLoading &&
//                                 index ==
//                                     (walletResponse?.transactions?.length ??
//                                         0)) {
//                               return const Center(
//                                   child: CircularProgressIndicator(
//                                 strokeWidth: 1,
//                               ));
//                             }
//                             return Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 42,
//                                       height: 42,
//                                       decoration: ShapeDecoration(
//                                         color: getIcon(walletResponse
//                                                 ?.transactions![index]
//                                                 .transactionFrom)
//                                             .withOpacity(0.3),
//                                         //Color(0xFFFEC7A4),
//                                         shape: const OvalBorder(),
//                                       ),
//                                       child: Icon(
//                                         Icons.account_balance_wallet,
//                                         color: getIcon(walletResponse
//                                             ?.transactions![index]
//                                             .transactionFrom),
//                                         size: 22.w,
//                                       ),
//                                     ),
//
//                                     // CircleAvatar(
//                                     //   child: Icon(
//                                     //     Icons.account_balance_wallet,
//                                     //     color: Colors.orange,
//                                     //   ),
//                                     //   radius: 25.w,
//                                     //   backgroundColor: Colors.orange
//                                     //       .withOpacity(0.2),
//                                     // ),
//                                     SizedBox(
//                                       width: 12.w,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${AppLocale.refNo.getString(context)} ${walletResponse?.transactions![index].orderId ?? ""}",
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 12.sp,
//                                             fontWeight: FontWeight.w600,
//                                             height: 1.38,
//                                           ),
//                                         ),
//
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         FutureBuilder<String>(
//                                           future: translateText(
//                                               "${walletResponse?.transactions![index].transactionAt ?? ""}" +
//                                                   " • "
//                                                       "${walletResponse?.transactions![index].transactionFrom ?? ""}"),
//                                           // Replace with your input and target language code
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return const CircularProgressIndicator();
//                                             } else if (snapshot.hasError) {
//                                               return const Text('');
//                                             } else {
//                                               return Text(
//                                                 snapshot.data ?? '',
//                                                 style: TextStyle(
//                                                   color:
//                                                       const Color(0xFF8C8C8C),
//                                                   fontSize: 10.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ); // Display translated title
//                                             }
//                                           },
//                                         ),
//
//                                         // Text(
//                                         //   "${walletResponse?.transactions![index].transactionAt ?? ""}" +
//                                         //       " • "
//                                         //           "${walletResponse?.transactions![index].transactionFrom ?? ""}",
//                                         //   style: TextStyle(
//                                         //     color: const Color(0xFF8C8C8C),
//                                         //     fontSize: 10.sp,
//                                         //     fontWeight: FontWeight.w500,
//                                         //   ),
//                                         // ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "${getStatusType(index) == 1 ? "+" : "-"} ",
//                                               // "TPs ${walletResponse?.transactions![index].transactionAmount ?? ""}",
//                                               style: TextStyle(
//                                                 color: getStatusType(index) == 1
//                                                     ? Colors.green
//                                                     : const Color(0xFFED3E55),
//                                                 fontSize: 12.sp,
//                                                 // fontFamily: 'Poppins',
//                                                 fontWeight: FontWeight.w600,
//                                                 height: 1.38,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 26,
//                                               width: 26,
//                                               child: Image.asset(
//                                                   'assets/images/tp_coin.png'),
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               "${walletResponse?.transactions![index].transactionAmount ?? ""}",
//                                               style: TextStyle(
//                                                 color: getStatusType(index) == 1
//                                                     ? Colors.green
//                                                     : const Color(0xFFED3E55),
//                                                 fontSize: 12.sp,
//                                                 // fontFamily: 'Poppins',
//                                                 fontWeight: FontWeight.w600,
//                                                 height: 1.38,
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         FutureBuilder<String>(
//                                           future: translateText(
//                                               "${walletResponse?.transactions![index].transactionType ?? ""}"),
//                                           // Replace with your input and target language code
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return const CircularProgressIndicator();
//                                             } else if (snapshot.hasError) {
//                                               return const Text('');
//                                             } else {
//                                               return Text(
//                                                 snapshot.data ?? '',
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 10.sp,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ); // Display translated title
//                                             }
//                                           },
//                                         ),
//
//                                         // Text(
//                                         //   "${walletResponse?.transactions![index].transactionType ?? ""}",
//                                         //   style: TextStyle(
//                                         //     color: Colors.black,
//                                         //     fontSize: 10.sp,
//                                         //     fontWeight: FontWeight.w500,
//                                         //   ),
//                                         // ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 const Divider()
//                               ],
//                             );
//                           },
//                           itemCount:
//                               (walletResponse?.transactions?.length ?? 0) +
//                                   (isLoading ? 1 : 0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   int getStatusType(int index) {
//     var status = walletResponse?.transactions![index].transactionType;
//     if (status == "Credited") {
//       return 1;
//     }
//     return 2;
//   }
//
//   String? checkWithdraw(
//       TextEditingController amountController, double minAmount) {
//     if (amountController.text.isNotEmpty) {
//       if (double.parse(amountController.text) > walletResponse!.wallet!) {
//         return "Entered amount should be less than ${walletResponse!.wallet}";
//       }
//       if (double.parse(amountController.text) < minAmount) {
//         return AppLocale.minimumShouldBeTP.getString(context) + " $minAmount";
//       }
//     }
//     return null;
//   }
//
//   Future<void> showWithdrawPopup() async {
//     if (walletResponse == null || walletResponse!.wallet! <= 0) {
//       return;
//     }
//     print(walletResponse?.minimumwithdrawamount);
//     var minAmt =
//         double.parse(walletResponse?.minimumwithdrawamount ?? "2500.0");
//     if (walletResponse!.wallet! < minAmt) {
//       showMinimumPopup(minAmt);
//       return;
//     }
//     var h1textStyle = TextStyle(
//       color: Colors.black,
//       fontSize: 10.sp,
//       // fontFamily: 'Poppins',
//       fontWeight: FontWeight.w600,
//       height: 1.66,
//     );
//     var textStyle = TextStyle(
//       color: Colors.black,
//       fontSize: 10.sp,
//       // fontFamily: 'Poppins',
//       fontWeight: FontWeight.w500,
//       height: 1.66,
//     );
//
//     TextEditingController _amountController = TextEditingController();
//     await showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         builder: (context) => StatefulBuilder(
//               builder: (context, setState) => SingleChildScrollView(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10)),
//                   ),
//                   constraints: const BoxConstraints(minHeight: 400),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         AppLocale.withdrawWalletAmount.getString(context),
//                         style: h1textStyle,
//                       ),
//                       TextField(
//                         onChanged: (value) {
//                           setState(() {});
//                         },
//                         keyboardType: const TextInputType.numberWithOptions(
//                             signed: false, decimal: true),
//                         decoration: InputDecoration(
//                           errorText:
//                               // (_amountController.text.isNotEmpty &&
//                               //         double.parse(_amountController.text) >
//                               //             walletResponse!.wallet!)
//                               checkWithdraw(_amountController, minAmt),
//                           // ? "Entered amount should be less than ${walletResponse!.wallet}"
//                           // : null,
//                           hintText: AppLocale.enterAmount.getString(context),
//                           hintStyle: textStyle.copyWith(
//                             color: const Color(0xFF8C8C8C),
//                           ),
//                           prefixIcon: Padding(
//                             padding: EdgeInsets.only(right: 20.w),
//                             child: Icon(Icons.wallet,
//                                 size: 20.w,
//                                 color:
//                                     checkWithdraw(_amountController, minAmt) !=
//                                             null
//                                         ? Colors.red
//                                         : Colors.black),
//                           ),
//                           prefixIconConstraints: BoxConstraints(minWidth: 30.w),
//                         ),
//                         style: textStyle.copyWith(
//                           color: Colors.black,
//                         ),
//                         controller: _amountController,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Center(
//                         child: InkWell(
//                           onTap: () {
//                             // showSnackBar(context, _amountController.text);
//                             var message;
//                             if (message =
//                                 checkWithdraw(_amountController, minAmt) !=
//                                     null) {
//                               debugPrint(message);
//                               return;
//                             }
//                             Navigator.pop(context);
//                             doWithdrawAmount(_amountController.text);
//                           },
//                           child: Container(
//                             width: 250.w,
//                             height: 40.h,
//                             // padding: EdgeInsets.all(8),
//                             decoration: ShapeDecoration(
//                               color: const Color(0xFFED3E55),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6.67),
//                               ),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   AppLocale.submit.getString(context),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     // fontFamily: 'Poppins',
//                                     fontWeight: FontWeight.w600,
//                                     height: 1.19,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//   }
//
//   Future<void> doWithdrawAmount(String text) async {
//     //doWithdrawAmount
//     try {
//       showLoaderDialog(context);
//       // final client = await RestClient.getRestClient();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var user = await prefs.getString("user");
//       UserData data = UserData.fromJson(jsonDecode(user!));
//       Map<String, String> body = HashMap();
//       body.putIfAbsent("user_id", () => data.userId.toString());
//       body.putIfAbsent("amount", () => text);
//       // RegistrationResponse response = await client.doWithdrawAmount(body);
//       var res = await ref.read(walletProvider).withdrawal(
//             context: context,
//             ref: ref,
//             body: body,
//           );
//       Navigator.pop(context);
//       if (res == true) {
//         // showSnackBar(context, response.message ?? "Failed");
//         loadWallet();
//       }
//     } catch (e) {
//       print(e);
//       showSnackBar(context,
//           AppLocale.withdrawAmountWillSendBusinessDays.getString(context));
//       Navigator.pop(context);
//     }
//   }
//
//   void showMinimumPopup(double minAmt) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: const EdgeInsets.all(6),
//           title: null,
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//           content: Container(
//             height: 155.h,
//             // width: 311.w,
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.close,
//                         size: 20,
//                       )),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text:
//                             AppLocale.minimumWithdrawalIsTP.getString(context) +
//                                 ' ${minAmt.toStringAsFixed(0)}' +
//                                 AppLocale.youHaveInsufficientFundsToWithdraw
//                                     .getString(context),
//                         style: const TextStyle(
//                           color: Color(0xFF170F49),
//                           fontSize: 12,
//                           // fontFamily: 'DM Sans',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       TextSpan(
//                         text: AppLocale.anyQuestionsPleaseWriteToUs
//                             .getString(context),
//                         style: const TextStyle(
//                           color: Color(0xFFED3E55),
//                           fontSize: 12,
//                           // fontFamily: 'DM Sans',
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     width: 132.63,
//                     height: 23.95,
//                     // padding: const EdgeInsets.symmetric(horizontal: 36.16, vertical: 20.26),
//                     clipBehavior: Clip.antiAlias,
//                     decoration: ShapeDecoration(
//                       color: const Color(0xFFE3EAFF),
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(
//                             width: 1, color: Color(0xFFED3E55)),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       shadows: [
//                         const BoxShadow(
//                           color: Color(0x3A4A3AFF),
//                           blurRadius: 17.08,
//                           offset: Offset(0, 9.69),
//                           spreadRadius: 0,
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           AppLocale.contactUs.getString(context),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 8,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Color getIcon(String? transactionFrom) {
//     // if (transactionFrom == "Spin") return Color(0xFFFEC7A4);
//     // if (transactionFrom == "Scratch Card") return Colors.blue.withOpacity(0.5);
//     if (transactionFrom == "Spin") return Colors.orange;
//     if (transactionFrom == "Scratch Card") return Colors.blue;
//     return Colors.purple;
//   }
// }


import 'dart:collection';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:offersapp/api/api_services/wallet_service.dart';
import 'package:offersapp/api/model/RegistrationResponse.dart';
import 'package:offersapp/api/model/WalletResponse.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../api/model/UserData.dart';
import 'HomePage.dart';

class WalletBalacePage extends ConsumerStatefulWidget {
  const WalletBalacePage({Key? key}) : super(key: key);

  @override
  _WalletBalacePageState createState() => _WalletBalacePageState();
}

class _WalletBalacePageState extends ConsumerState<WalletBalacePage> {
  var scrollController = ScrollController();
  // static const int PAGE_SIZE = 10;
  int start = 1;
  var walletProvider = ChangeNotifierProvider((ref) => WalletProvider());
  final FlutterLocalization _localization = FlutterLocalization.instance;
  bool _hasInteracted = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      start = 1;
    });
    scrollController.addListener(pagination);
    loadWallet();
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
        loadWallet();
      });
    }
  }

  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF3F6FF),
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
                      shadows: [
                        const BoxShadow(
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
                        dashPattern: [1, 2],
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
                                  AppLocale.availablePoints.getString(context),
                                  style: const TextStyle(
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
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Image.asset(
                                          'assets/images/tp_coin.png'),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
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

                // IconButton(
                //   onPressed: (){Navigator.pop(context);},
                //   icon: Icon(Icons.arrow_back,color: Colors.white,),
                // ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      AppLocale.myWallet.getString(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.19,
                      ),
                    ),
                  ),
                ),
              ]),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 20,
                        // ),
                        InkWell(
                          onTap: () {
                            showWithdrawPopup();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 11.h, bottom: 8.h),
                            width: 250.w,
                            height: 40.h,
                            decoration: ShapeDecoration(
                              color: walletResponse != null &&
                                  walletResponse!.wallet! > 0
                                  ? const Color(0xFFED3E55)
                                  : Colors.grey,
                              //if waller balance is zero, grey button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.67),
                              ),
                            ),
                            child:  Center(
                              child: Text(
                                AppLocale.redeemNow.getString(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.33,
                                  // fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              AppLocale.tpPoints.getString(context),
                              style:
                              TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // padding: EdgeInsets.symmetric(
                                //     vertical: 10.h, horizontal: 15.w
                                // ),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE3EAFF),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocale.earnedPoints.getString(context),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 1.66,
                                      ),
                                    ),
                                    Text(
                                      "${walletResponse?.taskearnings?.toStringAsFixed(2) ?? "0.0"}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                height: 65.h,
                                width: 149.w,
                              ),
                              Container(
                                height: 65.h,
                                width: 159.w,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE3EAFF),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocale.redeemedPoints.getString(context),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 1.66,
                                      ),
                                    ),
                                    Text(
                                      "${walletResponse?.withdraw?.toStringAsFixed(2) ?? "0.0"}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        // fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        height: 1.19,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocale.recentTransactions.getString(context),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                // fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.45,
                              ),
                            ),
                            // Text("Value"),
                          ],
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        //Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (isLoading &&
                                index ==
                                    (walletResponse?.transactions?.length ??
                                        0)) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ));
                            }
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: ShapeDecoration(
                                        color: getIcon(walletResponse
                                            ?.transactions![index]
                                            .transactionFrom)
                                            .withOpacity(0.3),
                                        //Color(0xFFFEC7A4),
                                        shape: const OvalBorder(),
                                      ),
                                      child: Icon(
                                        Icons.account_balance_wallet,
                                        color: getIcon(walletResponse
                                            ?.transactions![index]
                                            .transactionFrom),
                                        size: 22.w,
                                      ),
                                    ),

                                    // CircleAvatar(
                                    //   child: Icon(
                                    //     Icons.account_balance_wallet,
                                    //     color: Colors.orange,
                                    //   ),
                                    //   radius: 25.w,
                                    //   backgroundColor: Colors.orange
                                    //       .withOpacity(0.2),
                                    // ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${AppLocale.refNo.getString(context)} ${walletResponse?.transactions![index].orderId ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            height: 1.38,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder<String>(
                                          future: translateText(
                                              "${walletResponse?.transactions![index].transactionAt ?? ""}" +
                                                  " • "
                                                      "${walletResponse?.transactions![index].transactionFrom ?? ""}"),
                                          // Replace with your input and target language code
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else {
                                              return Text(
                                                snapshot.data ?? '',
                                                style: TextStyle(
                                                  color: const Color(0xFF8C8C8C),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ); // Display translated title
                                            }
                                          },
                                        ),

                                        // Text(
                                        //   "${walletResponse?.transactions![index].transactionAt ?? ""}" +
                                        //       " • "
                                        //           "${walletResponse?.transactions![index].transactionFrom ?? ""}",
                                        //   style: TextStyle(
                                        //     color: const Color(0xFF8C8C8C),
                                        //     fontSize: 10.sp,
                                        //     fontWeight: FontWeight.w500,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${getStatusType(index) == 1 ? "+" : "-"} ",
                                              // "TPs ${walletResponse?.transactions![index].transactionAmount ?? ""}",
                                              style: TextStyle(
                                                color: getStatusType(index) == 1
                                                    ? Colors.green
                                                    : const Color(0xFFED3E55),
                                                fontSize: 12.sp,
                                                // fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 1.38,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 26,
                                              width: 26,
                                              child: Image.asset('assets/images/tp_coin.png'),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "${walletResponse?.transactions![index].transactionAmount ?? ""}",
                                              style: TextStyle(
                                                color: getStatusType(index) == 1
                                                    ? Colors.green
                                                    : const Color(0xFFED3E55),
                                                fontSize: 12.sp,
                                                // fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                height: 1.38,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FutureBuilder<String>(
                                          future: translateText(
                                              "${walletResponse?.transactions![index].transactionType ?? ""}"),
                                          // Replace with your input and target language code
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
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
                                        //   "${walletResponse?.transactions![index].transactionType ?? ""}",
                                        //   style: TextStyle(
                                        //     color: Colors.black,
                                        //     fontSize: 10.sp,
                                        //     fontWeight: FontWeight.w500,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider()
                              ],
                            );
                          },
                          itemCount:
                          (walletResponse?.transactions?.length ?? 0) +
                              (isLoading ? 1 : 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getStatusType(int index) {
    var status = walletResponse?.transactions![index].transactionType;
    if (status == "Credited") {
      return 1;
    }
    return 2;
  }

  String? checkWithdraw(
      TextEditingController amountController, double minAmount) {
    if (amountController.text.isNotEmpty) {
      if (double.parse(amountController.text) > walletResponse!.wallet!) {
        return AppLocale.enteredAmountShouldBeLessThan.getString(context) + "${walletResponse!.wallet}";
      }
      if (double.parse(amountController.text) < minAmount) {
        return AppLocale.minimumShouldBeTP.getString(context)+"$minAmount";
      }
    }
    return null;
  }

  Future<void> showWithdrawPopup() async {
    if (walletResponse == null || walletResponse!.wallet! <= 0) {
      return;
    }
    print(walletResponse?.minimumwithdrawamount);
    var minAmt = double.parse(walletResponse?.minimumwithdrawamount ?? "200.0");
    if (walletResponse!.wallet! < minAmt) {
      showMinimumPopup(minAmt);
      return;
    }
    var h1textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      // fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      height: 1.66,
    );
    var textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      // fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.66,
    );

    TextEditingController _amountController = TextEditingController();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              constraints: const BoxConstraints(minHeight: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocale.withdrawWalletAmount.getString(context),
                    style: h1textStyle,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    decoration: InputDecoration(
                      errorText:
                      // (_amountController.text.isNotEmpty &&
                      //         double.parse(_amountController.text) >
                      //             walletResponse!.wallet!)
                      checkWithdraw(_amountController, minAmt),
                      // ? "Entered amount should be less than ${walletResponse!.wallet}"
                      // : null,
                      hintText: AppLocale.enterAmount.getString(context),
                      hintStyle: textStyle.copyWith(
                        color: const Color(0xFF8C8C8C),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Icon(Icons.wallet,
                            size: 20.w,
                            color:
                            checkWithdraw(_amountController, minAmt) !=
                                null
                                ? Colors.red
                                : Colors.black),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                    ),
                    style: textStyle.copyWith(
                      color: Colors.black,
                    ),
                    controller: _amountController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showSnackBar(context, _amountController.text);
                        var message;
                        if (message =
                            checkWithdraw(_amountController, minAmt) !=
                                null) {
                          debugPrint(message);
                          return;
                        }
                        Navigator.pop(context);
                        doWithdrawAmount(_amountController.text);

                      },
                      child: Container(
                        width: 250.w,
                        height: 40.h,
                        // padding: EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFED3E55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.67),
                          ),
                        ),
                        child:  Center(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              AppLocale.submit.getString(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                // fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> doWithdrawAmount(String text) async {
    //doWithdrawAmount
    try {
      showLoaderDialog(context);
      // final client = await RestClient.getRestClient();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData data = UserData.fromJson(jsonDecode(user!));
      Map<String, String> body = HashMap();
      body.putIfAbsent("user_id", () => data.userId.toString());
      body.putIfAbsent("amount", () => text);
      // RegistrationResponse response = await client.doWithdrawAmount(body);
      var res = await ref.read(walletProvider).withdrawal(
        context: context,
        ref: ref,
        body: body,
      );
      Navigator.pop(context);
      if (res == true) {
        // showSnackBar(context, response.message ?? "Failed");
        loadWallet();
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "Failed to Withdraw Amount. Please try again");
      Navigator.pop(context);
    }
  }

  void showMinimumPopup(double minAmt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6),
          title: null,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          content: Container(
            height: 155.h,
            // width: 311.w,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      )),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                        AppLocale.minimumWithdrawalIsTP.getString(context)+' ${minAmt.toStringAsFixed(0)}' +AppLocale.youHaveInsufficientFundsToWithdraw.getString(context),
                        style: const TextStyle(
                          color: Color(0xFF170F49),
                          fontSize: 12,
                          // fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: AppLocale.anyQuestionsPleaseWriteToUs.getString(context),
                        style: const TextStyle(
                          color: Color(0xFFED3E55),
                          fontSize: 12,
                          // fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 132.63,
                    height: 23.95,
                    // padding: const EdgeInsets.symmetric(horizontal: 36.16, vertical: 20.26),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE3EAFF),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFED3E55)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      shadows: [
                        const BoxShadow(
                          color: Color(0x3A4A3AFF),
                          blurRadius: 17.08,
                          offset: Offset(0, 9.69),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.contactUs.getString(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getIcon(String? transactionFrom) {
    // if (transactionFrom == "Spin") return Color(0xFFFEC7A4);
    // if (transactionFrom == "Scratch Card") return Colors.blue.withOpacity(0.5);
    if (transactionFrom == "Spin") return Colors.orange;
    if (transactionFrom == "Scratch Card") return Colors.blue;
    return Colors.purple;
  }
}

