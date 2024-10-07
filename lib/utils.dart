import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'api/apiEndpoints.dart';
import 'api/model/EarnGameResponses.dart';
import 'api/model/UserData.dart';

const titleHeaderColor = Colors.teal;

// const primaryColor = Color(0xFF072B4C);
const orangeColor = Color(0xFFF2BA47);
const placeHolder = Assets.imagesTurbopaisaLogoTwo;
const Color lightGrey = Color.fromRGBO(242, 242, 242, 1);
//http://mcg.mbitson.com/
const MaterialColor mcgpalette0 =
    MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
  50: Color(0xFFE1E6EA),
  100: Color(0xFFB5BFC9),
  200: Color(0xFF8395A6),
  300: Color(0xFF516B82),
  400: Color(0xFF2C4B67),
  500: Color(_mcgpalette0PrimaryValue),
  600: Color(0xFF062645),
  700: Color(0xFF05203C),
  800: Color(0xFF041A33),
  900: Color(0xFF021024),
});
const int _mcgpalette0PrimaryValue = 0xFF072B4C;

const MaterialColor mcgpalette0Accent =
    MaterialColor(_mcgpalette0AccentValue, <int, Color>{
  100: Color(0xFF5F92FF),
  200: Color(_mcgpalette0AccentValue),
  400: Color(0xFF004FF8),
  700: Color(0xFF0047DF),
});
const int _mcgpalette0AccentValue = 0xFF2C6FFF;

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: 1000),
    ),
  );
}

enum ApiStatus {
  Stable,
  Loading,
  Success,
  NetworkError,
  Error,
  NoData,
}

final FlutterLocalization _localization = FlutterLocalization.instance;
final translator = GoogleTranslator();

Future<String> translateText(String inputText) async {
  // print('THIS IS LOCAL LANG ${_localization.currentLocale}');
  // print('this is calls ok');
  var translation = await translator.translate(inputText,
      to: _localization.currentLocale.toString() == 'en_US'
          ? 'en'
          : _localization.currentLocale.toString() == 'HDI_IN'
              ? 'hi'
              : 'te');
  return translation.toString();
}

MySnackbar(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.pink.shade400,
      content: FutureBuilder<String>(
        future: translateText(msg),
        // Replace with your input and target language code
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('');
          } else {
            return Text(
              snapshot.data ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ); // Display translated title
          }
        },
      ),

      // Text(''
      //   //msg,
      //   style: TextStyle(
      //     color: Colors.white,
      //
      //   ),
      //),
      duration: Duration(seconds: 3),
    ),
  );
}

MySnackbarSuccess(context, msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green.shade400,
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}

navigateToNext(BuildContext context, Widget target) {
  Navigator.of(context).push(
    new MaterialPageRoute(
      builder: (context) {
        return target;
      },
    ),
  );
}

navigateToNextReplace(BuildContext context, Widget target) {
  Navigator.of(context).pushReplacement(
    new MaterialPageRoute(
      builder: (context) {
        return target;
      },
    ),
  );
}

showLoaderDialog(BuildContext context, {String? message}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
          margin: EdgeInsets.only(left: 7),
          child: Text(
            message ?? AppLocale.pleaseWait.getString(context),
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<void> requestNotificationPermissions() async {
  final PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    // Notification permissions granted
  } else if (status.isDenied) {
    // Notification permissions denied
    await openAppSettings();
  } else if (status.isPermanentlyDenied) {
    // Notification permissions permanently denied, open app settings
    await openAppSettings();
  }
}

Widget getNetworkImage(String? imageUrl,
    {double? width,
    double? height,
    String? placeholder,
    BoxFit? fit,
    Key? key}) {
  return CachedNetworkImage(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    imageUrl: imageUrl ?? "",
    // fit: fit ?? BoxFit.cover,
    fit: BoxFit.fill,
    key: key,
    placeholder: (context, url) => new Image(
      // fit: BoxFit.cover,
      fit: BoxFit.fill,
      image: AssetImage(placeholder ?? Assets.imagesAppLogo),
      height: double.infinity,
    ),
    errorWidget: (context, url, error) => new Image(
        fit: BoxFit.cover,
        image: AssetImage(placeholder ?? Assets.imagesAppLogo)),
  );
}

// Future<void> launchUrlBrowser(BuildContext context, String _url) async {
//   print("launchUrlBrowser: called");
//
//   if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication)) {
//     // throw Exception('Could not launch $_url');
//     showSnackBar(context, 'Could not launch $_url');
//   }
// }

// Future<void> launchUrlBrowser(BuildContext context, String _url) async {
//   print("launchUrlBrowser: called");
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   // Fetch the user data from SharedPreferences
//   var user = await prefs.getString("user");
//   UserData data = UserData.fromJson(jsonDecode(user!));
//
//   // Append the user_id to the URL as a query parameter
//   String urlWithUserId = "$_url&user_id=${data.userId}";
//   print('user_id_intex: ${data.userId}');
//
//   // Parse the original URL and extract 'p1' (user_id) and 'p2' (offer_id)
//   final uri = Uri.parse(_url);
//   String? offerIdFromP2 = uri.queryParameters['p2']; // Extracting offer_id from p2
//
//   if (offerIdFromP2 == null) {
//     print('Error: No p2 (offer_id) parameter found in the URL');
//     return;
//   }
//
//   print('Extracted offer_id (p2): $offerIdFromP2');
//
//   // Construct the API URL with the extracted user_id (p1) and offer_id (p2)
//   final apiUrl = Uri.parse(
//       '${ApiEndPoints.baseUrl}offers/getBanner?type=home&user_id=${data.userId}');
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'auth-key': 'earncashRestApi',
//   };
//
//   try {
//     final response = await http.get(apiUrl, headers: headers);
//
//     if (response.statusCode == 200) {
//       print('Response data: ${response.body}');
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
//
//   // Now construct the final URL with user_id and offer_id
//   String finalUrl =               launchUrlBrowser(context, banners[index].url ?? "");
//
//
//   // Launch the final URL
//   if (!await launchUrl(Uri.parse(finalUrl), mode: LaunchMode.externalApplication)) {
//     showSnackBar(context, 'Could not launch $finalUrl');
//   }
// }

// Future<void> launchUrlBrowser(BuildContext context, String url) async {
//   // Retrieve user data from SharedPreferences
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var user = await prefs.getString("user");
//   UserData data = UserData.fromJson(jsonDecode(user!));
//
//   // Construct URL with user_id
//   String urlWithUserId = "$url&user_id=${data.userId}";
//
//   print('user_id: ${data.userId}');
//
//   // Update API endpoint to include user_id
//   final apiUrl = Uri.parse(
//       '${ApiEndPoints.baseUrl}offers/getBanner?type=spinwheel&user_id=${data.userId}');
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'auth-key': 'earncashRestApi',
//   };
//
//   try {
//     final response = await http.get(apiUrl, headers: headers);
//
//     if (response.statusCode == 200) {
//       print('Response data: ${response.body}');
//     } else {
//       print('Request failed with status: ${response.statusCode}.');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
//
//   // Launch the URL with the appended user_id
//   if (!await launchUrl(Uri.parse(urlWithUserId),
//       mode: LaunchMode.externalApplication)) {
//     showSnackBar(context, 'Could not launch $urlWithUserId');
//   }
// }



Future<void> launchUrlBrowser(BuildContext context, dynamic userId,
    {required String url, required String earncashRestApi, String type = 'home',}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString("user");

  if (user != null) {
    UserData data = UserData.fromJson(jsonDecode(user));

    // Ensure the URL is correctly encoded
    String encodedUrl = Uri.encodeFull(url);

    // Construct the updated URL with userId and offerId
    String updatedUrl = encodedUrl.replaceAll(RegExp(r'p1=[^&]*'), 'p1=${data.userId}');
    String updatedUrls = encodedUrl.replaceAll(RegExp(r'p1=[^&]*'), 'p3=${data.gaid}');

    print('user_id: ${data.userId}');
    // print('Updated URL: $updatedUrl');

    // Construct API URL
    final apiUrl = Uri.parse(
        '${ApiEndPoints.baseUrl}offers/getBanner?type=home&user_id=${data.userId}');

    final headers = {
      'Content-Type': 'application/json',
      'auth-key': earncashRestApi,
    };

    try {
      final response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }

    // Launch the URL with the updated query parameters
    if (!await launchUrl(Uri.parse(updatedUrl),
        mode: LaunchMode.externalApplication)) {
      showSnackBar(context, 'Could not launch $updatedUrl');
    }
  } else {
    showSnackBar(context, 'User data not found');
  }
}
