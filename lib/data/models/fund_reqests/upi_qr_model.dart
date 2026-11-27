class UpiQrModel {
  final String? orderId;
  final String? amount;
  final String? qrString;
  final int? gatewayOrderId;
  final String? merchantOrderId;

  UpiQrModel({
    this.orderId,
    this.amount,
    this.gatewayOrderId,
    this.merchantOrderId,
    this.qrString,
  });

  factory UpiQrModel.fromJson(Map<String, dynamic> json) => UpiQrModel(
        orderId: json["order_id"]?.toString(),
        amount: json["amount"]?.toString(),
        qrString: json["qrString"]?.toString(),
        merchantOrderId: json["merchant_order_id"],
        gatewayOrderId: json["gateway_order_id"] is int
            ? json["gateway_order_id"]
            : int.tryParse(json["gateway_order_id"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "amount": amount,
        "qrString": qrString,
        "gateway_order_id": gatewayOrderId,
        "merchant_order_id": merchantOrderId,
      };
}
