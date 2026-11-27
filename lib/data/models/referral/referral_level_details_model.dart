// class ReferralLevelDetailsModel {
//   final String? name;
//   final String? email;
//   final String? referralCode;
//   final String? walletBalance;
//   final String? level;

//   ReferralLevelDetailsModel({
//     this.name,
//     this.email,
//     this.referralCode,
//     this.walletBalance,
//     this.level,
//   });

//   factory ReferralLevelDetailsModel.fromJson(Map<String, dynamic> json) =>
//       ReferralLevelDetailsModel(
//         name: json["name"],
//         email: json["email"],
//         referralCode: json["referral_code"],
//         walletBalance: json["wallet_balance"],
//         level: json["level"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "email": email,
//         "referral_code": referralCode,
//         "wallet_balance": walletBalance,
//         "level": level,
//       };
// }

class ReferralLevelDetailsModel {
  final int? id;
  final String? name;
  final String? email;
  final String? referralCode;
  final String? walletBalance;
  final ReferredLevel? referredLevel;

  ReferralLevelDetailsModel({
    this.id,
    this.name,
    this.email,
    this.referralCode,
    this.walletBalance,
    this.referredLevel,
  });

  factory ReferralLevelDetailsModel.fromJson(Map<String, dynamic> json) =>
      ReferralLevelDetailsModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        referralCode: json["referral_code"],
        walletBalance: json["wallet_balance"],
        referredLevel: json["referred_level"] == null
            ? null
            : ReferredLevel.fromJson(json["referred_level"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "referral_code": referralCode,
        "wallet_balance": walletBalance,
        "referred_level": referredLevel?.toJson(),
      };
}

class ReferredLevel {
  final int? totalDownline;
  final String? currentRank;

  ReferredLevel({
    this.totalDownline,
    this.currentRank,
  });

  factory ReferredLevel.fromJson(Map<String, dynamic> json) => ReferredLevel(
        totalDownline: json["total_downline"],
        currentRank: json["current_rank"],
      );

  Map<String, dynamic> toJson() => {
        "total_downline": totalDownline,
        "current_rank": currentRank,
      };
}
