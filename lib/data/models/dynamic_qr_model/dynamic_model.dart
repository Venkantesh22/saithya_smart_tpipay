import 'package:lekra/services/constants.dart';

class DynamicModel {
  final String? vpa;
  final String? qrString;
  final int? orderId;
  final double? amount;

  DynamicModel({
    this.vpa,
    this.qrString,
    this.orderId,
    this.amount,
  });

  factory DynamicModel.fromJson(Map<String, dynamic> json) => DynamicModel(
        vpa: json["vpa"],
        qrString: json["qrString"],
        orderId: json["order_id"],
        amount: double.tryParse(json["amount" ] ??"") ,
      );

  Map<String, dynamic> toJson() => {
        "vpa": vpa,
        "qrString": qrString,
        "order_id": orderId,
        "amount": amount,
      };


      DynamicModel copyWith({
        int? orderId,
        String? qrString,
        String? vpa,
        double? amount,
    }) => 
        DynamicModel(
            orderId: orderId ?? this.orderId,
            qrString: qrString ?? this.qrString,
            vpa: vpa ?? this.vpa,
            amount: amount ?? this.amount,
        );

  String get formatAmount =>
      PriceConverter.convertToNumberFormat(amount ?? 0.00);
}
