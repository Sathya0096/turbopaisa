class BankDetailsResponse {
  String? userId;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? upiId;

  BankDetailsResponse(
      {this.userId,
      this.accountNumber,
      this.ifscCode,
      this.bankName,
      this.upiId});

  BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    accountNumber = json['account_number'];
    ifscCode = json['ifsc_code'];
    bankName = json['bank_name'];
    upiId = json['upi_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['account_number'] = this.accountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['bank_name'] = this.bankName;
    data['upi_id'] = this.upiId;
    return data;
  }
}