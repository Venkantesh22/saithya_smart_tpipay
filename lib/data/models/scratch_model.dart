class ScratchCardModel {
  final int? id;
  final String? code;
  final String? type;
  final String? rewardPoints;
  final DateTime? expiryDate;
  final int? isRedeemed;
  final bool? isScratched;

  const ScratchCardModel({
    this.id,
    this.code,
    this.type,
    this.rewardPoints,
    this.expiryDate,
    this.isRedeemed,
    this.isScratched,
  });

  factory ScratchCardModel.fromJson(Map<String, dynamic> json) {
    bool scratched = false;
    if (json["is_scratched"] != null) {
      scratched = json["is_scratched"] == true ||
          json["is_scratched"] == 1 ||
          json["is_scratched"].toString() == "1" ||
          json["is_scratched"].toString().toLowerCase() == "true";
    }

    int redeemed = 0;
    if (json["is_redeemed"] != null) {
      if (json["is_redeemed"] is bool) {
        redeemed = json["is_redeemed"] == true ? 1 : 0;
      } else {
        redeemed = int.tryParse(json["is_redeemed"].toString()) ?? 0;
      }
    }
    if (scratched) redeemed = 1;

    return ScratchCardModel(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
      code: json["code"]?.toString(),
      type: json["type"]?.toString(),
      rewardPoints: json["reward_points"]?.toString() ?? json["won_amount"]?.toString(),
      expiryDate: json["expiry_date"] == null
          ? null
          : DateTime.tryParse(json["expiry_date"].toString()),
      isRedeemed: redeemed,
      isScratched: scratched || redeemed == 1,
    );
  }

  ScratchCardModel copyWith({
    int? id,
    String? code,
    String? type,
    String? rewardPoints,
    DateTime? expiryDate,
    int? isRedeemed,
    bool? isScratched,
  }) {
    return ScratchCardModel(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      expiryDate: expiryDate ?? this.expiryDate,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      isScratched: isScratched ?? this.isScratched,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "type": type,
        "reward_points": rewardPoints,
        "expiry_date": expiryDate?.toIso8601String(),
        "is_redeemed": isRedeemed,
        "is_scratched": isScratched,
      };

  bool get isScratch => (isScratched == true) || ((isRedeemed ?? 0) == 1);
  bool get isDiscount => type == "discount";

  /// Returns true if the scratch card is expired
  bool get isExpiry {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }
}
