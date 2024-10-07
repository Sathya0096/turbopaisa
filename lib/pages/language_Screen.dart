import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:offersapp/Config/app_route.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import '../generated/assets.dart';
import '../pages/dashboard_page.dart';
import '../utils/app_colors.dart';
import 'HomePage.dart';

class LanguageIntro extends StatefulWidget {
  const LanguageIntro({super.key});

  @override
  State<LanguageIntro> createState() => _LanguageIntroState();
}

class _LanguageIntroState extends State<LanguageIntro> {
  String selectedLanguage = 'English';
  final FlutterLocalization _localization = FlutterLocalization.instance;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
      print("Loaded language: $selectedLanguage"); // Debug statement
    });
  }

  Future<String> translateText(String inputText) async {
    var translation = await translator.translate(inputText,
        to: _localization.currentLocale.toString() == 'en_US'
            ? 'en'
            : _localization.currentLocale.toString() == 'HDI_IN'
            ? 'hi'
            : 'te');
    return translation.toString();
  }

  void _onLanguageSelected(String language) {
    setState(() {
      selectedLanguage = language;
      print("Selected language: $selectedLanguage"); // Debug statement
      switch (language) {
        case 'English':
          _localization.translate('en');
          _saveSelectedLanguage('English');
          break;
        case 'हिंदी':
          _localization.translate('HDI');
          _saveSelectedLanguage('Hindi');
          break;
        case 'తెలుగు':
          _localization.translate('TEL');
          _saveSelectedLanguage('Telugu');
          break;
      }
    });
  }

  void _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language);
    print("Saved language: $language"); // Debug statement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration:
              const BoxDecoration(gradient: AppColors.appLoginGradientBg),
            ),
            Positioned(
              bottom: -20,
              left: 0,
              right: 0,
              child: RotatedBox(
                quarterTurns: 90,
                child: ClipPath(
                  clipper: GreenClipperReverse(),
                  child: Container(
                    height: 115,
                    color: const Color(0xff222467),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 31),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  "assets/images/turbopaisa_logo_two.png",
                                  width: 90,
                                ),
                              ),
                              const SizedBox(height: 51),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SvgPicture.asset(
                                      Assets.svgRegisterRectangle,
                                      width: 217,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 13),
                                          child: Text(
                                            AppLocale.chooseLanguage
                                                .getString(context),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              height: 1.06,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Text('English',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    Radio<String>(
                                      value: 'English',
                                      groupValue: selectedLanguage,
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          _onLanguageSelected(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Text('हिंदी',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Radio<String>(
                                      value: 'हिंदी',
                                      groupValue: selectedLanguage,
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          _onLanguageSelected(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7)
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Text('తెలుగు',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Radio<String>(
                                      value: 'తెలుగు',
                                      groupValue: selectedLanguage,
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          _onLanguageSelected(value);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocale.languageChosen.getString(context),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    ' : $selectedLanguage',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  )
                                ],
                              ),
                              const SizedBox(height: 25),
                              InkWell(
                                onTap: (){
                                  Get.toNamed(Routes.splashScreen);
                                },
                                child: Container(
                                  height: 40,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: const Color(0xffED3E55),
                                  ),
                                  child:  Center(
                                      child: Text(
                                        AppLocale.clickToContinue.getString(context),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 60),
                              Padding(
                                padding: const EdgeInsets.only(left: 7, top: 20),
                                child: Row(
                                  children: [
                                    Image.asset("assets/images/coin.png"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset("assets/images/coin_two.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
