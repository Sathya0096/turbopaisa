import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/dashboard_page.dart';
import '../../pages/otp_verification_page.dart';
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import 'network_error.dart';

class LoginProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;

  login({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.login, body: body);
    print(ApiEndPoints.login);
    print(response);
    print('api login for otp sathya');

    // print(body);
    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body']['response'];
      // showSnackBar(context!, res['message']);
      // print(res);
      if( response['body']['status'] == 404){
        MySnackbar(context,
            // 'message'
           AppLocale.invalidDetails.getString(context!)
    );
        Navigator.pop(context!);
      }else{
        navigateToNext(context!, VerificationPage(mobile: res['mobile'], userId: int.parse(res['user_id'].toString()),login: true));
        notifyListeners();
        return true;
      }
      // if(res['otp_verify'] == 'N'){
      // }
      // else{
      //   await prefs.setString("user", jsonEncode(res));
      //   Navigator.pop(context!);
      //   Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(
      //       builder: (context) => DashboardPage(),
      //     ),
      //   );
      // }
      // Navigator.pop(context!);
      // if(res['status']==200)Navigator.pop(context);
      //
      // navigateToNext(context, VerificationPage(mobile: body['mobile'], userId: res['result']['user_id']));

    }
    else if (response['status'] == 'No Connection') {
        status = ApiStatus.NetworkError;
        notifyListeners();
        Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
        return false;
      }
    else {
      status = ApiStatus.Error;
      notifyListeners();
    }
  }

}

