import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pages/localization_language.dart';
import '../../pages/otp_verification_page.dart';
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import 'network_error.dart';

class RegisterProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;

  register({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.registerNewUser, body: body);
    print(ApiEndPoints.registerNewUser);
    print(response);

    print(body);
    if (response['status'] == 200) {
      print('aaya');
      status = ApiStatus.Success;

      var res = response['body'];
      if(res['status'] == 406){
        Navigator.pop(context!);
        showSnackBar(context, res[
        showSnackBar(context, AppLocale.userAlreadyExistedWithThisMobileNumber.getString(context))
            ]);
      }
      else{
        print(res);

        if(res['status']==200)Navigator.pop(context!);

        navigateToNext(context!, VerificationPage(mobile: body['mobile'], userId: res['result']['user_id']));

      }
      // showSnackBar(context!, res['message']);

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

