import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translator/translator.dart';

final userInfoProvider = ChangeNotifierProvider((ref) => UserInfo());

class UserInfo extends ChangeNotifier {
  final translator = GoogleTranslator();
  final FlutterLocalization _localization = FlutterLocalization.instance;

  Future<String> translateText(String inputText) async {
    var translation = await translator.translate(
        inputText, to: _localization.currentLocale == 'en_US' ? 'en' : 'te');
    return translation.toString();
  }

  void changeLocalisation(String lang) {
    _localization.translate(lang);
    notifyListeners();
  }
}
