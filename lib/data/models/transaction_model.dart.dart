class TransactionModel {
  int? id;
  String? type;
  double? amount;
  String? balanceAfter;
  String? description;
  DateTime? createdAt;
  final String? orderId;
  final String? gatewayOrderId;
  final String? status;
  final String? utr;
  final String? product; // Added to capture 'addfund'
  final String? mobile;
  final String? operatorId;
  final String? operatorTxnId;
  final String? remark;

  TransactionModel({
    this.id,
    this.type,
    this.amount,
    this.balanceAfter,
    this.description,
    this.createdAt,
    this.orderId,
    this.gatewayOrderId,
    this.status,
    this.utr,
    this.product,
    this.mobile,
    this.operatorId,
    this.operatorTxnId,
    this.remark,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        // If 'type' is missing but 'product' is 'addfund', treat it as a credit
        type: json["type"] ?? (json["product"] == "addfund" ? "credit" : null),
        // Safely parse amount whether it comes as String, Int, or Double
        amount: json["amount"] == null
            ? null
            : double.tryParse(json["amount"].toString()),
        balanceAfter: json["balance_after"]?.toString(),
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]).toLocal(),
        orderId: json["order_id"]?.toString(),
        gatewayOrderId: json["gateway_order_id"]?.toString(),
        status: json["status"],
        utr: json["utr"]?.toString(),
        product: json["product"],
        mobile: json["mobile"],
        operatorId: json["operator_id"],
        operatorTxnId: json["operator_txn_id"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "gateway_order_id": gatewayOrderId,
        "id": id,
        "type": type,
        "amount": amount,
        "balance_after": balanceAfter,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "status": status,
        "utr": utr,
        "product": product,
        "mobile": mobile,
        "operator_id": operatorId,
        "operator_txn_id": operatorTxnId,
        "remark": remark,
      };

  bool get isDebit => (type?.toLowerCase() == "debit");

  TransactionModel copyWith({
    int? id,
    String? type,
    double? amount,
    String? balanceAfter,
    String? description,
    DateTime? createdAt,
    String? orderId,
    String? gatewayOrderId,
    String? status,
    String? utr,
    String? product,
    String? mobile,
    String? operatorId,
    String? operatorTxnId,
    String? remark,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      orderId: orderId ?? this.orderId,
      gatewayOrderId: gatewayOrderId ?? this.gatewayOrderId,
      status: status ?? this.status,
      utr: utr ?? this.utr,
      product: product ?? this.product,
      mobile: mobile ?? this.mobile,
      operatorId: operatorId ?? this.operatorId,
      operatorTxnId: operatorTxnId ?? this.operatorTxnId,
      remark: remark ?? this.remark,
    );
  }

  String get transactionTitle {
    if (product == "Mobile Recharge") {
      return "Mobile Recharge";
    } else if (product == "addfund") {
      return "Wallet Recharge / Add Fund";
    } else if (product == "subscription" || (description?.toLowerCase().contains("membership") ?? false)) {
      return "Membership Plan";
    } else {
      return description ?? "Transaction";
    }
  }
}
