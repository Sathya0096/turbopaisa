import 'package:flutter/material.dart';

// var production = true;

class ApiEndPoints {

  // static String baseUrl = 'https://app.turbopaisa.com/services/';
  static String baseUrl = 'https://dev.turbopaisa.com/services/';

  static String getMyOffersDetailspagination = "offers/getMyOffersDetailspagination";
  static String getupcomingofferDetails = 'offers/getupcomingofferDetails';

  static String insertUpdateFcmToken = 'users/insertUpdateFcmToken';

  static String getMyOffers = "offers/getMyOffers";
  static String getUpcomingOffers = 'offers/getUpcomingOffers';
  static String getAllOffers = 'offers/getOffers';
  static String getOfferDetailsById = 'offers/getOfferDetailsById';
  static String withdrawAmount = 'users/withdrawAmount';
  static String getMyTransactions = 'cashfreepayout/getMyTransactions';

  static String getofferDetails = 'offers/getofferDetails';
  static String addBeneficiary = 'users/addBeneficiary';
  static String changePassword = "users/changePassword";
  static String registerNewUser = "users/create";
  static String getSettingsInfo = 'offers/getSettingsInfo';
  static String resendOtp = "users/resendOtp";
  static String login = "users/login";
  static String verifyOtp = 'users/verifyOtp';
  static String daily5Points = 'users/check_user_status';
  // static String spinNew = '${baseUrl}spin/insertClaimedSpinAmount';

}