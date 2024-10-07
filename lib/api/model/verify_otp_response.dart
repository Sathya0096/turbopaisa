import 'package:offersapp/api/model/UserData.dart';

class VerifyOTPResponse {
  int? status;
  String? message;
  UserData? result;

  VerifyOTPResponse({this.status, this.message, this.result});

  VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
        json['result'] != null ? new UserData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

// class Result {
//   String? userId;
//   String? name;
//   String? mobile;
//   String? email;
//   String? pincode;
//   String? password;
//   String? deviceId;
//   String? gaid;
//   String? ipaddress;
//   String? loginToken;
//   String? userUniqueId;
//   String? referralId;
//   String? wallet;
//   String? taskEarnings;
//   String? withdraw;
//   String? createdAt;
//   String? updatedAt;
//   String? status;
//   String? otp;
//
//   Result(
//       {this.userId,
//         this.name,
//         this.mobile,
//         this.email,
//         this.pincode,
//         this.password,
//         this.deviceId,
//         this.gaid,
//         this.ipaddress,
//         this.loginToken,
//         this.userUniqueId,
//         this.referralId,
//         this.wallet,
//         this.taskEarnings,
//         this.withdraw,
//         this.createdAt,
//         this.updatedAt,
//         this.status,
//         this.otp});
//
//   Result.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     name = json['name'];
//     mobile = json['mobile'];
//     email = json['email'];
//     pincode = json['pincode'];
//     password = json['password'];
//     deviceId = json['device_id'];
//     gaid = json['gaid'];
//     ipaddress = json['ipaddress'];
//     loginToken = json['login_token'];
//     userUniqueId = json['user_unique_id'];
//     referralId = json['referral_id'];
//     wallet = json['wallet'];
//     taskEarnings = json['task_earnings'];
//     withdraw = json['withdraw'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     status = json['status'];
//     otp = json['otp'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['name'] = this.name;
//     data['mobile'] = this.mobile;
//     data['email'] = this.email;
//     data['pincode'] = this.pincode;
//     data['password'] = this.password;
//     data['device_id'] = this.deviceId;
//     data['gaid'] = this.gaid;
//     data['ipaddress'] = this.ipaddress;
//     data['login_token'] = this.loginToken;
//     data['user_unique_id'] = this.userUniqueId;
//     data['referral_id'] = this.referralId;
//     data['wallet'] = this.wallet;
//     data['task_earnings'] = this.taskEarnings;
//     data['withdraw'] = this.withdraw;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['status'] = this.status;
//     data['otp'] = this.otp;
//     return data;
//   }
// }
