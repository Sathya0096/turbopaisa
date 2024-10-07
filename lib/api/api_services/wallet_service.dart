// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:offersapp/api/model/OffersData.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../pages/localization_language.dart';
// import '../../pages/otp_verification_page.dart';
// import '../../utils.dart';
// import '../apiEndpoints.dart';
// import '../api_provider.dart';
// import '../model/WalletResponse.dart';
// import 'network_error.dart';
//
// class WalletProvider extends ChangeNotifier{
//
//   ApiStatus status = ApiStatus.Stable;
//   List data = [];
//
//   withdrawal({
//     BuildContext? context,
//     WidgetRef? ref,
//     var body,
//   }) async {
//     status = ApiStatus.Loading;
//     notifyListeners();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var response = await ApiProvider.post(url:ApiEndPoints.withdrawAmount, body: body);
//     print(ApiEndPoints.withdrawAmount);
//     print(response);
//
//     print(body);
//     if (response['status'] == 200) {
//       status = ApiStatus.Success;
//
//       var res = response['body'];
//       if(res['status'] == 404){
//         MySnackbar(context!, res[
//             'message'
//             // AppLocale.welcome.getString(context)
//         ]);
//       }else{
//         MySnackbar(context!, res[
//         AppLocale.pleaseEnterBankAccountDetails.getString(context)
//         //  'message'
//         ]);
//       }
//
//       print(res);
//
//       // navigateToNext(context, VerificationPage(mobile: body['mobile'], userId: data.result!.userId!));
//
//       notifyListeners();
//       return true;
//     }
//     else if (response['status'] == 'No Connection') {
//       status = ApiStatus.NetworkError;
//       notifyListeners();
//       Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
//       return false;
//     } else {
//       status = ApiStatus.Error;
//       notifyListeners();
//       // MySnackbar(context, response['message']);
//     }
//   }
//
//   transactions({
//     BuildContext? context,
//     WidgetRef? ref,
//     String? pagenumber,
//     String? user_id,
//     String? count,
//   }) async {
//     status = ApiStatus.Loading;
//     if(pagenumber=='1')data.clear();
//     notifyListeners();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     print('userId=> $user_id');
//     var response = await ApiProvider.get(ApiEndPoints.getMyTransactions, queryParam: {
//       'pagenumber': pagenumber,
//       'user_id': user_id,
//       // 'count': count,
//     });
//     print(ApiEndPoints.getMyTransactions);
//     print(response);
//
//     if (response['status'] == 200) {
//       status = ApiStatus.Success;
//
//       var res = response['body'];
//       // MySnackbar(context!, res['message']);
//       print(res);
//       data.add(WalletResponse.fromJson(res));
//       // WalletResponse.fromJson(json);
//       // navigateToNext(context, VerificationPage(mobile: body['mobile'], userId: data.result!.userId!));
//
//       notifyListeners();
//       return true;
//     } else if (response['status'] == 'No Connection') {
//       status = ApiStatus.NetworkError;
//       notifyListeners();
//       Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
//       return false;
//     } else {
//       status = ApiStatus.Error;
//       notifyListeners();
//     }
//   }
//
// }
//

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/otp_verification_page.dart';
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import '../model/WalletResponse.dart';
import 'network_error.dart';

class WalletProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;
  List data = [];

  withdrawal({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.withdrawAmount, body: body);
    print(ApiEndPoints.withdrawAmount);
    print(response);

    print(body);
    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body'];
      if(res['status'] == 404){
        // MySnackbar(context!, res['message']);
      }else{
        MySnackbar(context!, res['message']);
      }

      print(res);

      // navigateToNext(context, VerificationPage(mobile: body['mobile'], userId: data.result!.userId!));

      notifyListeners();
      return true;
    }
    else if (response['status'] == 'No Connection') {
      status = ApiStatus.NetworkError;
      notifyListeners();
      Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
      return false;
    } else {
      status = ApiStatus.Error;
      notifyListeners();
      // MySnackbar(context, response['message']);
    }
  }

  transactions({
    BuildContext? context,
    WidgetRef? ref,
    String? pagenumber,
    String? user_id,
    String? count,
  }) async {
    status = ApiStatus.Loading;
    if(pagenumber=='1')data.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('userId=> $user_id');
    var response = await ApiProvider.get(ApiEndPoints.getMyTransactions, queryParam: {
      'pagenumber': pagenumber,
      'user_id': user_id,
      // 'count': count,
    });
    print(ApiEndPoints.getMyTransactions);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body'];
      // MySnackbar(context!, res['message']);
      print(res);
      data.add(WalletResponse.fromJson(res));
      // WalletResponse.fromJson(json);
      // navigateToNext(context, VerificationPage(mobile: body['mobile'], userId: data.result!.userId!));

      notifyListeners();
      return true;
    } else if (response['status'] == 'No Connection') {
      status = ApiStatus.NetworkError;
      notifyListeners();
      Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
      return false;
    } else {
      status = ApiStatus.Error;
      notifyListeners();
    }
  }

}





