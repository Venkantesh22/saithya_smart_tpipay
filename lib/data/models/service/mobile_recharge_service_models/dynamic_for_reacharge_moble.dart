class DynamicForRechargeMobileModel {
  final int? rechargeId;
  final String? mobile;
  final String? amount;
  final String? qr;
  final String? vpa;
  final int? orderId;

  DynamicForRechargeMobileModel({
    this.rechargeId,
    this.mobile,
    this.amount,
    this.qr,
    this.vpa,
    this.orderId,
  });

  factory DynamicForRechargeMobileModel.fromJson(Map<String, dynamic> json) =>
      DynamicForRechargeMobileModel(
        rechargeId: json["recharge_id"],
        mobile: json["mobile"],
        amount: json["amount"],
        qr: json["qr"],
        vpa: json["vpa"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "recharge_id": rechargeId,
        "mobile": mobile,
        "amount": amount,
        "qr": qr,
        "vpa": vpa,
        "order_id": orderId,
      };
}
