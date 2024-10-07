class WalletResponse {
  double? wallet;
  double? taskearnings;
  double? withdraw;
  String? minimumwithdrawamount;
  List<Transactions>? transactions;

  WalletResponse(
      {this.wallet,
      this.taskearnings,
      this.withdraw,
      this.transactions,
      this.minimumwithdrawamount});

  WalletResponse.fromJson(Map<String, dynamic> json) {
    wallet = json['wallet'].toDouble();
    taskearnings = json['taskearnings'].toDouble();
    withdraw = json['withdraw'].toDouble();
    minimumwithdrawamount = json['minimumwithdrawamount'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet'] = this.wallet;
    data['taskearnings'] = this.taskearnings;
    data['withdraw'] = this.withdraw;
    data['minimumwithdrawamount'] = this.minimumwithdrawamount;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? orderId;
  String? transactionAmount;
  String? transactionType;
  String? transactionFrom;
  String? transactionAt;
  String? transactionStatus;

  Transactions(
      {this.orderId,
      this.transactionAmount,
      this.transactionType,
      this.transactionFrom,
      this.transactionAt,
      this.transactionStatus});

  Transactions.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    transactionAmount = json['transaction_amount'];
    transactionType = json['transaction_type'];
    transactionFrom = json['transaction_from'];
    transactionAt = json['transaction_at'];
    transactionStatus = json['transaction_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['transaction_amount'] = this.transactionAmount;
    data['transaction_type'] = this.transactionType;
    data['transaction_from'] = this.transactionFrom;
    data['transaction_at'] = this.transactionAt;
    data['transaction_status'] = this.transactionStatus;
    return data;
  }
}
