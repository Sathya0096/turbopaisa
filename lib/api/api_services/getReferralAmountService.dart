// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:offersapp/api/model/OffersData.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../utils.dart';
// import '../apiEndpoints.dart';
// import '../api_provider.dart';
// import '../model/UserData.dart';
// import 'network_error.dart';
//
// class ReferralProvider extends ChangeNotifier{
//
//   var referralAmount = '0';
//   ApiStatus status = ApiStatus.Stable;
//
//   getDetails({
//     BuildContext? context,
//     WidgetRef? ref,
//   })
//   async {
//     status = ApiStatus.Loading;
//     notifyListeners();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var user = await prefs.getString("user");
//     UserData data = UserData.fromJson(jsonDecode(user!));
//     var response = await ApiProvider.post(url:ApiEndPoints.getSettingsInfo, body: {
//       'user_id': data.userId.toString(),
//     });
//     print(ApiEndPoints.getSettingsInfo);
//     print(response);
//
//     if (response['status'] == 200) {
//       status = ApiStatus.Success;
//
//       var res = jsonDecode(response['body']);
//       referralAmount = res['resultMessage']['referral_amount'].toString();
//       print(res);
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
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import '../model/UserData.dart';
import 'network_error.dart';

class ReferralProvider extends ChangeNotifier {
  var referralAmount = '0';
  var tutorialLink = ''; // Add this field to store the tutorial link
  ApiStatus status = ApiStatus.Stable;

  Future<bool> getDetails({
    BuildContext? context,
    WidgetRef? ref,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    UserData data = UserData.fromJson(jsonDecode(user!));

    var response = await ApiProvider.post(
      url: ApiEndPoints.getSettingsInfo,
      body: {
        'user_id': data.userId.toString(),
      },
    );

    print(ApiEndPoints.getSettingsInfo);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;
      var res = jsonDecode(response['body']);

      // Extract referral_amount and tutorial_link
      referralAmount = res['resultMessage']['referral_amount'].toString();
      tutorialLink = res['resultMessage']['tutorial_link'].toString();

      print(res);
      notifyListeners();
      return true;
    } else if (response['status'] == 'No Connection') {
      status = ApiStatus.NetworkError;
      notifyListeners();
      Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => NetworkError()),
      );
      return false;
    } else {
      status = ApiStatus.Error;
      notifyListeners();
      return false;
    }
  }
}

