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

class OffersProvider extends ChangeNotifier{

  var myOffersData = [];

  ApiStatus status = ApiStatus.Stable;

  int myOfferCurrentPage = 1,myOfferLastPage=1;

  getMyOffers({
    BuildContext? context,
    WidgetRef? ref,
    int? pageNumber,
    String? userId,
  }) async {
    status = ApiStatus.Loading;
    myOfferCurrentPage = 1;
    myOfferLastPage = 1;
    myOffersData.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('debug 2.1');
    var response = await ApiProvider.post(url:ApiEndPoints.getMyOffers+'?pagenumber=$pageNumber&count=10', body:
      {
        'user_id': userId,
      },
    );
    print('debug 2.2');
    print(ApiEndPoints.getMyOffers);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body']['data'];
      myOfferCurrentPage = response['body']['pagination']['current_page'];
      myOfferLastPage = response['body']['pagination']['total_page'];
      print(res);
      print('done');
      List tempData  = res;

      tempData.forEach((element) {
        myOffersData.add(OffersData.fromJson(element));
      });

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

  getAllOffers({
    BuildContext? context,
    WidgetRef? ref,
    int? pageNumber,
    String? userId,
  }) async {
    status = ApiStatus.Loading;
    myOfferCurrentPage = 1;
    myOfferLastPage = 1;
    myOffersData.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('debug 2.1');
    print('pageNumber: $pageNumber');
    var response = await ApiProvider.post(url:ApiEndPoints.getAllOffers+'?pagenumber=$pageNumber&count=10', body:
    {
      'user_id': userId,
    },
    );
    print('debug 2.2');
    print('userId => $userId');
    print(ApiEndPoints.getAllOffers+'pagenumber=$pageNumber');
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body']['data'];
      myOfferCurrentPage = response['body']['pagination']['current_page'];
      myOfferLastPage = response['body']['pagination']['total_page'];
      print(res);
      print('done');
      List tempData  = res;

      tempData.forEach((element) {
        myOffersData.add(OffersData.fromJson(element));
        print(element['images'][0]['icon']);
        print('okokok');
      });

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

  getOfferDetailsById({
    BuildContext? context,
    WidgetRef? ref,
    String? id,
    String? userId,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await ApiProvider.post(url:ApiEndPoints.getOfferDetailsById, body:
    {
      'offer_id': id,
      'user_id': userId,
    },
    );

    print(ApiEndPoints.getAllOffers);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body'];

      print(res);
      print('done');
      List tempData  = res;

      tempData.forEach((element) {
        myOffersData.add(OffersData.fromJson(element));
      });

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

  getUpcomingOffers({
    BuildContext? context,
    WidgetRef? ref,
    int? pageNumber,
    String? userId,
  }) async {
    status = ApiStatus.Loading;
    myOfferCurrentPage = 1;
    myOfferLastPage = 1;
    myOffersData.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('debug 2.1');
    var response = await ApiProvider.post(url:ApiEndPoints.getUpcomingOffers+'?pagenumber=$pageNumber&count=10', body:
    {
      'user_id': userId,
    },
    );
    print('debug 2.2');
    print(ApiEndPoints.getUpcomingOffers);
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body']['data'];
      myOfferCurrentPage = response['body']['pagination']['current_page'];
      myOfferLastPage = response['body']['pagination']['total_page'];
      print(res);
      print('done');
      List tempData  = res;

      tempData.forEach((element) {
        myOffersData.add(OffersData.fromJson(element));
      });

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

  updateFcmToken({
    BuildContext? context,
    WidgetRef? ref,
    var body,
  }) async {
    status = ApiStatus.Loading;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await ApiProvider.post(url:ApiEndPoints.insertUpdateFcmToken, body: body,);
    print(ApiEndPoints.insertUpdateFcmToken);
    print(response);
    print(body);
    if (response['status'] == 200) {
      status = ApiStatus.Success;


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

  // getAllOffers({
  //   BuildContext? context,
  //   WidgetRef? ref,
  //   String? pageNumber,
  //   String? userId,
  // }) async {
  //   status = ApiStatus.Loading;
  //   myOffersData.clear();
  //   notifyListeners();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print('debug 2.1');
  //   var response = await ApiProvider.get(ApiEndPoints.getofferDetails, queryParam:
  //   {
  //     'user_id': userId,
  //     'pagenumber': pageNumber,
  //     'count': '10',
  //   },
  //   );
  //   print('debug 2.2');
  //   print(ApiEndPoints.getofferDetails);
  //   print(response);
  //
  //   if (response['status'] == 200) {
  //     status = ApiStatus.Success;
  //
  //     var res = response['body'];
  //
  //     print(res);
  //     print('done');
  //     List tempData  = res;
  //
  //     tempData.forEach((element) {
  //       myOffersData.add(OffersData.fromJson(element));
  //     });
  //
  //     notifyListeners();
  //     return true;
  //   } else if (response['status'] == 'No Connection') {
  //     status = ApiStatus.NetworkError;
  //     notifyListeners();
  //     Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
  //     return false;
  //   } else {
  //     status = ApiStatus.Error;
  //     notifyListeners();
  //   }
  // }
  //
  // getUpcomingOffers({
  //   BuildContext? context,
  //   WidgetRef? ref,
  //   String? pageNumber,
  //   String? userId,
  // }) async {
  //   status = ApiStatus.Loading;
  //   myOffersData.clear();
  //   notifyListeners();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print('debug 2.1');
  //   var response = await ApiProvider.get(ApiEndPoints.getupcomingofferDetails, queryParam:
  //   {
  //     'user_id': userId,
  //     'pagenumber': pageNumber,
  //     'count': '10',
  //   },
  //   );
  //   print('debug 2.2');
  //   print(ApiEndPoints.getupcomingofferDetails);
  //   print(response);
  //
  //   if (response['status'] == 200) {
  //     status = ApiStatus.Success;
  //
  //     var res = response['body'];
  //
  //     print(res);
  //     print('done');
  //     List tempData  = res;
  //
  //     tempData.forEach((element) {
  //       myOffersData.add(OffersData.fromJson(element));
  //     });
  //
  //     notifyListeners();
  //     return true;
  //   } else if (response['status'] == 'No Connection') {
  //     status = ApiStatus.NetworkError;
  //     notifyListeners();
  //     Navigator.push(context!, MaterialPageRoute(builder: (context)=>NetworkError()));
  //     return false;
  //   } else {
  //     status = ApiStatus.Error;
  //     notifyListeners();
  //   }
  // }

}

