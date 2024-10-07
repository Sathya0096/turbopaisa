import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offersapp/api/model/OffersData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils.dart';
import '../apiEndpoints.dart';
import '../api_provider.dart';
import 'network_error.dart';

class ChangepasswordProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;

  changePassword({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.changePassword, body: body);
    print(ApiEndPoints.changePassword);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body'];
      showSnackBar(context!, res['result'] ?? "");
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

}

