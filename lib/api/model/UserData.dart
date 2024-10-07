class UserData {
  String? userId;
  String? name;
  String? mobile;
  String? email;
  String? pincode;
  String? password;
  String? deviceId;
  String? gaid;
  String? loginToken;
  String? userUniqueId;
  String? referralId;
  String? wallet;
  String? taskEarnings;
  String? withdraw;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? message;
  String? earnedAmount;

  UserData(
      {this.userId,
      this.name,
      this.mobile,
      this.email,
      this.pincode,
      this.password,
      this.deviceId,
      this.gaid,
      this.loginToken,
      this.userUniqueId,
      this.referralId,
      this.wallet,
      this.taskEarnings,
      this.withdraw,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.message,
      this.earnedAmount
      });

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    pincode = json['pincode'];
    password = json['password'];
    deviceId = json['device_id'];
    gaid = json['gaid'];
    loginToken = json['login_token'];
    userUniqueId = json['user_unique_id'];
    referralId = json['referral_id'];
    wallet = json['wallet'];
    taskEarnings = json['task_earnings'];
    withdraw = json['withdraw'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    message = json['message'];
    earnedAmount = json['earnedAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['pincode'] = this.pincode;
    data['password'] = this.password;
    data['device_id'] = this.deviceId;
    data['gaid'] = this.gaid;
    data['login_token'] = this.loginToken;
    data['user_unique_id'] = this.userUniqueId;
    data['referral_id'] = this.referralId;
    data['wallet'] = this.wallet;
    data['task_earnings'] = this.taskEarnings;
    data['withdraw'] = this.withdraw;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['message'] = this.message;
    data['earnedAmount'] = this.earnedAmount;
    return data;
  }
}
