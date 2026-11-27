import 'package:lekra/services/constants.dart';

class RechargeSuccessModel {
  final String? reqid;
  final String? mobile;
  final String? amount;
  final String? status;
  final String? remark;
  final String? operatorTxnId;
  final String? errorCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RechargeSuccessModel({
    this.reqid,
    this.mobile,
    this.amount,
    this.status,
    this.remark,
    this.operatorTxnId,
    this.errorCode,
    this.createdAt,
    this.updatedAt,
  });

  factory RechargeSuccessModel.fromJson(Map<String, dynamic> json) =>
      RechargeSuccessModel(
        reqid: json["reqid"],
        mobile: json["mobile"],
        amount: json["amount"]?.toString(),
        status: json["status"],
        remark: json["remark"],
        operatorTxnId: json["operator_txn_id"],
        errorCode: json["error_code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "reqid": reqid,
        "mobile": mobile,
        "amount": amount,
        "status": status,
        "remark": remark,
        "operator_txn_id": operatorTxnId,
        "error_code": errorCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  String get formatAmount => PriceConverter.convertToNumberFormat(
      double.tryParse(amount ?? "0.0") ?? 0.0);
}
