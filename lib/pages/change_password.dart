import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offersapp/api/api_services/changePasswordService.dart';
import 'package:offersapp/api/model/RegistrationResponse.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/model/ChangePasswordResponse.dart';
import 'HomePage.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {

  var changePasswordProvider = ChangeNotifierProvider((ref) => ChangepasswordProvider());

  String _oldPassword = "";
  String _newPassword = "";
  String _confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    var commonSpace = 16.h;
    var textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.66,
    );
    var h1textStyle = TextStyle(
      color: Colors.black,
      fontSize: 10.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      height: 1.66,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // rgba(224, 234, 255, 0.48), rgba(224, 234, 255, 0.52), rgba(224, 234, 255, 1)
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(224, 234, 255, 0.48),
                  Color.fromRGBO(224, 234, 255, 0.52),
                  Color.fromRGBO(224, 234, 255, 1),
                ]),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 62.sp),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: RotatedBox(
                  quarterTurns: 90,
                  child: ClipPath(
                    clipper: GreenClipperReverse(),
                    child: Container(
                      height: 115.h,
                      color: Color(0xff222467),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
                  child: Icon(Icons.arrow_back_rounded),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 62.sp),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 21.h,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/images/turbopaisa_logo_two.png",
                          height: 69.h,
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: SvgPicture.asset(
                              Assets.svgRegisterRectangle,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                // height: 0.97,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      Text(
                        'Old Password ',
                        style: h1textStyle,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Type your old password",
                          hintStyle: textStyle.copyWith(
                            color: Color(0xFF8C8C8C),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Icon(
                              Icons.lock,
                              size: 20.w,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                        ),
                        style: textStyle.copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _oldPassword = value;
                        },
                      ),
                      SizedBox(
                        height: commonSpace,
                      ),
                      Text(
                        'New Password ',
                        style: h1textStyle,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Type your new password",
                          hintStyle: textStyle.copyWith(
                            color: Color(0xFF8C8C8C),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Icon(
                              Icons.lock,
                              size: 20.w,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                        ),
                        style: textStyle.copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _newPassword = value;
                        },
                      ),
                      SizedBox(
                        height: commonSpace,
                      ),
                      Text(
                        'Confirm Password ',
                        style: h1textStyle,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Type your confirm password",
                          hintStyle: textStyle.copyWith(
                            color: Color(0xFF8C8C8C),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Icon(
                              Icons.lock,
                              size: 20.w,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 30.w),
                        ),
                        style: textStyle.copyWith(
                          color: Colors.black,
                        ),
                        onChanged: (value) {
                          _confirmPassword = value;
                        },
                      ),
                      SizedBox(
                        height: commonSpace,
                      ),
                      SizedBox(
                        height: 44.sp,
                      ),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          submitData();
                        },
                        child: Container(
                          width: 250.w,
                          height: 40.h,
                          decoration: ShapeDecoration(
                            color: Color(0xFFED3E55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.67),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.19,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.w, top: 40.w),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/coin.png",
                              // width: 80,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            "assets/images/coin_two.png",
                            //width: 80,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitData() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_oldPassword.isEmpty ||
          _newPassword.isEmpty ||
          _confirmPassword.isEmpty) {
        showSnackBar(context, "Please enter all the fields.");
        return;
      } else if (_newPassword != _confirmPassword) {
        showSnackBar(context, "Mismatch confirm password.");
        return;
      }

      showLoaderDialog(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      UserData userData = UserData.fromJson(jsonDecode(user!));
      Map<String, String> body = HashMap();
      body.putIfAbsent("user_id", () => userData.userId.toString());
      body.putIfAbsent("password", () => _oldPassword);
      body.putIfAbsent("newpassword", () => _newPassword);

      var res = await ref.read(changePasswordProvider).changePassword(
        body: body,context: context,ref: ref,
      );

      if (res == true) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      showSnackBar(context, "Failed to change password.");
      Navigator.pop(context);
    }
  }
}
