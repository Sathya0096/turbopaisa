import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/HomePage.dart';
import '../../pages/dashboard_page.dart';
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import 'network_error.dart';

class ResendOTPProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;

  resend({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.resendOtp, body: body);
    print(ApiEndPoints.resendOtp);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success; 

      var res = response['body'];
      showSnackBar(context!, res['message'] ?? "");
      print(res);

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

  verify({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.verifyOtp, body: body);
    print(ApiEndPoints.verifyOtp);
    print(response);
    print(response['body']);
    print(response['body']['result']);
    if (response['body']['status'] == 200) {
      status = ApiStatus.Success;

      Navigator.pop(context!);
      showSnackBar(context, AppLocale.loggedInSuccessfully.getString(context));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user", jsonEncode(response['body']['result']!));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return DashboardPage();
        },
      ), (route) => false);

      notifyListeners();
      return true;
    }
    else if (response['status'] == 'No Connection') {
      status = ApiStatus.NetworkError;
      notifyListeners();
      Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
      return false;
    } else {
      showSnackBar(context!, AppLocale.invalidOTP.getString(context));
      Navigator.pop(context);
      status = ApiStatus.Error;
      notifyListeners();
    }
  }

}

