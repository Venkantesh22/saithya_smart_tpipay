
import 'package:lekra/services/constants.dart';

class DynamicWalletPaymentDoneModel {
    final String? orderId;
    final String? merchantOrderId;
    final String? amount;
    final String? status;
    final String? utr;
    final String? paymentMethod;
    final DateTime? paidAt;

    DynamicWalletPaymentDoneModel({
        this.orderId,
        this.merchantOrderId,
        this.amount,
        this.status,
        this.utr,
        this.paymentMethod,
        this.paidAt,
    });

    factory DynamicWalletPaymentDoneModel.fromJson(Map<String, dynamic> json) => DynamicWalletPaymentDoneModel(
        orderId: json["order_id" ] ??"",
        merchantOrderId: json["merchant_order_id"] ??"",
        amount: json["amount"] ??"",
        status: json["status"] ??"",
        utr: json["utr"],
        paymentMethod: json["payment_method"] ??"",
        paidAt: json["paid_at"] == null ? null : DateTime.parse(json["paid_at"]).toLocal(),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "merchant_order_id": merchantOrderId,
        "amount": amount,
        "status": status,
        "utr": utr,
        "payment_method": paymentMethod,
        "paid_at": paidAt?.toIso8601String(),
    };

    String get formatAmount => PriceConverter.convertToNumberFormat(double.tryParse(amount ?? "0.0") ?? 0.0 );
}
