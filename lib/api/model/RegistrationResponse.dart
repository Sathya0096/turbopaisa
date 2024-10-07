class RegistrationResponse {
  int? status;
  String? message;
  Result? result;

  RegistrationResponse({this.status, this.message, this.result});

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  int? userId;
  String? otp;

  Result({this.userId, this.otp});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['otp'] = this.otp;
    return data;
  }
}

// class RegistrationResponse {
//   int? status;
//   String? message;
//   int? userId;
//
//   RegistrationResponse({this.status, this.message, this.userId});
//
//   RegistrationResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     userId = json['UserId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['UserId'] = this.userId;
//     return data;
//   }
// }
