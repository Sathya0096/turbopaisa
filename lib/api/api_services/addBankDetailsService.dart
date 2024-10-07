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

class BankDetailsProvider extends ChangeNotifier{

  ApiStatus status = ApiStatus.Stable;

  submitBankDetails({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.addBeneficiary, body: body);
    // print(ApiEndPoints.addBeneficiary);
    // print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body'];
      // showSnackBar(context!, res['message'] ?? "");
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

