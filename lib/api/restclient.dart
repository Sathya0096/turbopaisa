import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:offersapp/api/model/BannersResponse.dart';
import 'package:offersapp/api/model/ChangePasswordResponse.dart';
import 'package:offersapp/api/model/EarnGameResponses.dart';
import 'package:offersapp/api/model/RegistrationResponse.dart';
import 'package:offersapp/api/model/ScratchCardResponse.dart';
import 'package:offersapp/api/model/SpinWheelResponse.dart';
import 'package:offersapp/api/model/WalletResponse.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import 'PrettyDioLogger.dart';
import 'StringResponseConverter.dart';
import 'apiEndpoints.dart';
import 'model/BankDetailsResponse.dart';
import 'model/OffersData.dart';
import 'model/UserData.dart';
import 'model/verify_otp_response.dart';

part 'restclient.g.dart';

// const String BASE_URL = "https://macsof.in/advertiseApp/services/";

//https://macsof.in/advertiseApp/services/earngames/getEarngames?user_id=3
// const PLACE_HOLDER_PROFILE = "assets/images/profile_pic.png";

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static Future<RestClient> getRestClient({BuildContext? context}) async {
    // LoginResponse? user = await AuthMethods().getUserDetails();
    //BaseOptions options =  BaseOptions(
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(milliseconds: 60 * 1000), // 60 seconds
      receiveTimeout: Duration(milliseconds: 60 * 1000), // 60 seconds
    );

    // String baseUrl = FlavorConfig.instance.variables["baseUrl"];
    // print(baseUrl);
    options.baseUrl = ApiEndPoints.baseUrl;
    final dio = Dio(options);
    dio.interceptors.clear();
    dio.interceptors.add(StringResponseConverter());
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options); //modify your request
        },
        onResponse: (response, handler) {
          if (response != null) {
            //on success it is getting called here
            return handler.next(response);
          } else {
            return null;
          }
        },
        onError: (DioError e, handler) async {
          if (e.response != null) {
            if (e.response?.statusCode == 401) {
              if (context != null) {
                // print("Token Expired. Logged out.");
                showSnackBar(context, "Token Expired. Logged out.");
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('user');
                //Provider.of<UserProvider>(context, listen: false).logout();
              }
              return null;
            }
          }
          // try{
          //   DioError err = e as DioError;
          //   var message = ResponceMessage.fromJson(json.decode(err.response!.data));
          //   APIException(message);
          //   return handler.next(e);
          // }catch(e1){
          //   return handler.next(e1);
          // }

          return handler.next(e);
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
    }

    dio.options.headers["auth-key"] = "earncashRestApi";
    final client = RestClient(dio);
    return client;
  }

  //===User management [START]

  @POST("users/login")
  Future<UserData> doLogin(@Body() Map<String, String> loginRequestBody);

  @POST("users/create")
  Future<RegistrationResponse> doRegister(
      @Body() Map<String, String> loginRequestBody);

  @POST("users/forgotPassword")
  Future<RegistrationResponse> forgotPassword(
      @Body() Map<String, String> loginRequestBody);

  @POST("users/verifyOtp")
  Future<VerifyOTPResponse> verifyOtp(@Body() Map<String, String> body);

  @GET("offers/getOffers")
  Future<List<OffersData>> getOffers(@Query("user_id") String userId);

  @GET("offers/getupcomingOffers")
  Future<List<OffersData>> getUpComingOffers(@Query("user_id") String userId);

  @GET("offers/getupcomingofferDetails")
  Future<List<OffersData>> getUpcomingofferDetails(
      @Query("user_id") String userId,
      @Query("pagenumber") int pagenumber,
      @Query("count") int count);

  @POST("offers/getMyOffersDetailspagination")
  Future<List<OffersData>> getMyOffersDetailspagination(
      @Query("pagenumber") int pagenumber,
      @Query("count") int count,
      @Body() Map<String, String> body);

  @POST("offers/getMyOffer")
  Future<List<OffersData>> getMyOffer(@Body() Map<String, String> body);

  @GET("offers/getofferDetails")
  Future<List<OffersData>> getofferDetails(
    @Query("user_id") String userId,
    @Query("pagenumber") int pagenumber,
    @Query("count") int count,
  );

  @GET("offers/getBanner")
  Future<BannersResponse> getBanners(@Query("type") String type);

  @GET("scratchcard/getScratchcards")
  Future<ScratchCardResponse> getScratchcards(@Query("user_id") String userId);

  // @GET("cashfreepayout/getTransactions")
  // Future<WalletResponse> getTransactions(@Query("user_id") String userId);

  @GET("cashfreepayout/getMyTransactions?user_id=2&pagenumber=1&count=10")
  Future<WalletResponse> getTransactions(
    @Query("user_id") String userId,
    @Query("pagenumber") int pagenumber,
    @Query("count") int count,
  );

  @POST("scratchcard/scratchcardUserinsert")
  Future<RegistrationResponse> scratchcardUserinsert(
      @Body() Map<String, String> body);

  @GET("spin/getSpins")
  Future<List<SpinWheelResponse>> getSpins(@Query("user_id") String userId);

  @POST("spin/getMySpinCards")
  Future<List<SpinWheelResponse>> getMySpinCards(
      @Body() Map<String, String> body);

  @POST("spin/spinUserinsert")
  Future<RegistrationResponse> spinUserinsert(@Body() Map<String, String> body);

//https://macsof.in/advertiseApp/services/earngames/getEarngames?user_id=3

  @GET("earngames/getEarngames")
  Future<EarnGameResponses> getEarngame(@Query("user_id") String userId);

  @POST("offers/getOfferDetailsById")
  Future<List<OffersData>> getOfferDetailsById(
      @Body() Map<String, String> body);

  @POST("users/withdrawAmount")
  Future<RegistrationResponse> doWithdrawAmount(
      @Body() Map<String, String> body);

  @POST("users/changePassword")
  Future<ChangePasswordResponse> doChangePassword(
      @Body() Map<String, String> body);

  @POST("users/resendOtp")
  Future<ChangePasswordResponse> resendOtp(@Body() Map<String, String> body);

  @POST("users/addBeneficiary")
  Future<ChangePasswordResponse> addBeneficiary(
      @Body() Map<String, String> body);

  @POST("users/updatelocation")
  Future<ChangePasswordResponse> updatelocation(
      @Body() Map<String, String> body);

  @POST("cashfreepayout/getBeneficiaryDetailsById")
  Future<List<BankDetailsResponse>> getBeneficiaryDetailsById(
      @Body() Map<String, String> body);
}
