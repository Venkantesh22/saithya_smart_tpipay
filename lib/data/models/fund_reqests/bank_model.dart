class BankModel {
  final int? id;
  final String? accountName;
  final String? accountNumber;
  final String? ifsc;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BankModel({
    this.id,
    this.accountName,
    this.accountNumber,
    this.ifsc,
    this.createdAt,
    this.updatedAt,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        id: json["id"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        ifsc: json["ifsc"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_name": accountName,
        "account_number": accountNumber,
        "ifsc": ifsc,
        "created_at": createdAt?.toIso8601String(),
        "updatedAt": createdAt?.toIso8601String(),
      };
}
