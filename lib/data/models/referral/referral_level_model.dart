// class ReferralLevelModel {
//   final int? level;
//   final int? count;
//   final List<ReferralUserModel>? referralUserModel;

//   ReferralLevelModel({
//     this.level,
//     this.count,
//     this.referralUserModel,
//   });

//   factory ReferralLevelModel.fromJson(Map<String, dynamic> json) =>
//       ReferralLevelModel(
//         level: json["level"],
//         count: json["count"],
//         referralUserModel: json["users"] == null
//             ? []
//             : List<ReferralUserModel>.from(
//                 json["users"]!.map((x) => ReferralUserModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "level": level,
//         "count": count,
//         "users": referralUserModel == null
//             ? []
//             : List<dynamic>.from(referralUserModel!.map((x) => x.toJson())),
//       };
// }

// class ReferralUserModel {
//   final int? id;
//   final String? name;
//   final String? email;
//   final String? referralCode;
//   final String? walletBalance;
//   final int? level;

//   ReferralUserModel({
//     this.id,
//     this.name,
//     this.email,
//     this.referralCode,
//     this.walletBalance,
//     this.level,
//   });

//   factory ReferralUserModel.fromJson(Map<String, dynamic> json) =>
//       ReferralUserModel(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         referralCode: json["referral_code"],
//         walletBalance: json["wallet_balance"],
//         level: json["level"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "referral_code": referralCode,
//         "wallet_balance": walletBalance,
//         "level": level,
//       };
// }
class ReferralLevelModel {
  final int? levelNumber;
  final int? currentPeopleInLevel;

  ReferralLevelModel({
    this.levelNumber,
    this.currentPeopleInLevel,
  });

  factory ReferralLevelModel.fromJson(Map<String, dynamic> json) =>
      ReferralLevelModel(
        levelNumber: json["level_number"],
        currentPeopleInLevel: json["current_people_in_level"],
      );

  Map<String, dynamic> toJson() => {
        "level_number": levelNumber,
        "current_people_in_level": currentPeopleInLevel,
      };
}
