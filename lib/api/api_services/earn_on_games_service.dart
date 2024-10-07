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

class EarnOnGamesData{
  String code,url,name,image,category;
  EarnOnGamesData({
    required this.code,
    required this.url,
    required this.name,
    required this.image,
    required this.category,
  });
}

class EarnOnGamesProvider extends ChangeNotifier{

  var gamesData = [];
  ApiStatus status = ApiStatus.Stable;

  getGames({
    BuildContext? context,
    WidgetRef? ref,
  }) async {
    status = ApiStatus.Loading;
    gamesData.clear();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('debug 2.1');
    // var response = await ApiProvider.get2('https://pub.gamezop.com/v3/games?id=4253&lang=639', queryParam: {});
    var response = await ApiProvider.get2('https://pub.gamezop.com/v3/games?id=8073&lang=en', queryParam: {});

    print('debug 2.2');
    print('https://pub.gamezop.com/v3/games');
    print(response);

    if (response['status'] == 200) {
      status = ApiStatus.Success;

      var res = response['body']['games'];

      print(res);
      print('done');
      List tempData  = res;
      Map<String, List<EarnOnGamesData>> separatedData = {};

      for (var game in res) {
        List<String> categories = List<String>.from(game['categories']['en']);

        for (var category in categories) {
          if (!separatedData.containsKey(category)) {
            separatedData[category] = [];
          }
          separatedData[category]!.add(
              EarnOnGamesData(
                code: game['code'].toString(),
                url: game['url'].toString(),
                name: game['name']['en'].toString(),
                image: game['assets']['cover'].toString(),
                category: game['categories']['en'][0].toString(),
              )
          );
        }
      }
      print(separatedData);

      separatedData.forEach((key,value) {
        gamesData.add(
          {
            'category': key,
            'games': value,
          }
        );
      });
      print(gamesData);
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

