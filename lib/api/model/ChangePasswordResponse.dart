class ChangePasswordResponse {
  int? status;
  String? message;
  String? result;

  ChangePasswordResponse({this.status, this.message, this.result});

  ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
