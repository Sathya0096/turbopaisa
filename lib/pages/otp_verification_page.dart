import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offersapp/api/api_services/resendOtp.dart';
import 'package:offersapp/api/model/ChangePasswordResponse.dart';
import 'package:offersapp/api/model/UserData.dart';
import 'package:offersapp/api/model/verify_otp_response.dart';
import 'package:offersapp/api/restclient.dart';
import 'package:offersapp/generated/assets.dart';
import 'package:offersapp/pages/dashboard_page.dart';
import 'package:offersapp/pages/localization_language.dart';
import 'package:offersapp/utils.dart';
import 'package:offersapp/utils/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class VerificationPage extends ConsumerStatefulWidget {
  final int userId;
  final String mobile;
  bool login;
  VerificationPage({Key? key,this.login = false,required this.userId, required this.mobile})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  String otp = "";

  var resendOtpProvider = ChangeNotifierProvider((ref) => ResendOTPProvider());
  int _counter = 30;
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_counter == 0) {
        timer.cancel();
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              'OTP',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
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
                        AppLocale.codeHasSentTo.getString(context),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.59,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        '${widget.mobile}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                        ),
                      ),
                      SizedBox(
                        height: 48.h,
                        child: Container(),
                      ),
                      // SizedBox(
                      //   height: 46.h,
                      //   child: Container(
                      //     color: Colors.green,
                      //   ),
                      // ),
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.8,
                        child: PinCodeTextField(
                          appContext: context,
                          hintStyle: TextStyle(color: Colors.yellow),
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          length: 4,
                          obscureText: false,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            // if (v!.length < 4) {
                            //   return "Please enter valid OTP";
                            // } else {
                            //   return null;
                            // }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(9.24.w),
                            fieldHeight: 50.w,
                            fieldWidth: 50.w,
                            activeFillColor: Colors.red,
                            activeColor: AppColors.primaryColor,
                            selectedColor: AppColors.primaryColor,
                            selectedFillColor: Colors.grey.shade100,
                            inactiveColor: Colors.grey.shade500,
                            inactiveFillColor: Colors.grey.shade100,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          // controller: _otpController,
                          enableActiveFill: false,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            otp = v;
                          },
                          beforeTextPaste: (text) {
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                          onChanged: (String value) {
                            otp = value;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 51.h,
                        child: Container(),
                      ),
                      Text(
                        AppLocale.haventReceivedTheVerificationCode.getString(context),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.59,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if(_counter == 0){
                            resendOtpApi();
                          }
                        },
                        child: Text(
                            _counter == 0 ? AppLocale.resend.getString(context) : AppLocale.resendOTP.getString(context) + '($_counter)',
                          style: TextStyle(
                            color: _counter == 0 ? Color(0xFFED3E55) : Colors.grey,
                            fontSize: 12.sp,
                            // fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.59,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 64.h,
                        child: Container(),
                      ),
                      InkWell(
                        onTap: () {
                          submitOTP();
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
                             AppLocale.verify.getString(context),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.33,
                                fontWeight: FontWeight.w600,
                                height: 1.24,
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

  Future<void> submitOTP() async {
    try {
      showLoaderDialog(context);
      final client = await RestClient.getRestClient();
      Map<String, String> body = HashMap();
      body.putIfAbsent("user_id", () => widget.userId.toString());
      body.putIfAbsent("otp", () => otp);

      // VerifyOTPResponse data = await client.verifyOtp(body);
     var res = await ref.read(resendOtpProvider).verify(
       body: body,ref: ref,context: context,
     );
    } catch (e) {
      print(e);
      showSnackBar(context, AppLocale.invalidOTP.getString(context));
      Navigator.pop(context);
    }
  }

  Future<void> resendOtpApi() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      showLoaderDialog(context);
      final client = await RestClient.getRestClient();

      Map<String, String> body = HashMap();
      body.putIfAbsent("mobile", () => widget.mobile);
      // ChangePasswordResponse data = await client.resendOtp(body);
      var res = await ref.read(resendOtpProvider).resend(
        body: body,ref: ref,context: context,
      );
      if(res == true){
        _counter = 30;
        startTimer();
        setState(() {});
        Navigator.pop(context);
      }

    } catch (e) {
      print(e);
      showSnackBar(context, AppLocale.failedToResendPassword.getString(context));
      Navigator.pop(context);
    }
  }
}
