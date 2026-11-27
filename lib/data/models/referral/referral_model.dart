// import 'dart:convert';

// class ReferralModel {
//   final String? name;
//   final String? email;
//  final  double? wallet;
//   final String? referralCode;
//   final int? level;
//   final List<ReferralModel>? referrals;

//   ReferralModel({
//     this.name,
//     this.email,
//     this.wallet,
//     this.referralCode,
//     this.level,
//     this.referrals,
//   });

//   factory ReferralModel.fromJson(Map<String, dynamic> json) {
//     return ReferralModel(
//       name: json['name']?.toString(),
//       email: json['email']?.toString(),
//       wallet: json['wallet'] == null,
//       level: json['level'],
//       referralCode: json["referral_code"],
//       referrals: (json['referrals'] as List<dynamic>? ?? [])
//           .map((e) => ReferralModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//         'wallet': wallet,
//         "referral_code": referralCode,
//         'level': level,
//         'referrals': referrals?.map((r) => r.toJson()).toList(),
//       };

//   /// Encode this model to a JSON string
//   String toRawJson() => jsonEncode(toJson());

//   /// Decode from a JSON string
//   factory ReferralModel.fromRawJson(String str) =>
//       ReferralModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
// }


// referral_model.dart
import 'dart:convert';

class ReferralModel {
  final String? name;
  final String? email;
  final String? wallet; // store as string for safe display
  final String? referralCode;
  final int? level;
  final List<ReferralModel>? referrals;

  ReferralModel({
    this.name,
    this.email,
    this.wallet,
    this.referralCode,
    this.level,
    this.referrals,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    String? parseWallet(dynamic w) {
      if (w == null) return null;
      // Convert any numeric or string value to a normalized string
      if (w is String) return w;
      if (w is int || w is double || w is num) return w.toString();
      try {
        return w.toString();
      } catch (_) {
        return null;
      }
    }

    int? parseLevel(dynamic l) {
      if (l == null) return null;
      if (l is int) return l;
      if (l is double) return l.toInt();
      if (l is String) {
        final clean = l.trim();
        return int.tryParse(clean);
      }
      return null;
    }

    List<ReferralModel>? parseReferrals(dynamic r) {
      if (r == null) return null;
      if (r is List) {
        return r
            .where((e) => e != null)
            .map<ReferralModel?>((e) {
              try {
                return ReferralModel.fromJson(e as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            })
            .whereType<ReferralModel>()
            .toList();
      }
      return null;
    }

    return ReferralModel(
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      wallet: parseWallet(json['wallet']),
      referralCode: json['referral_code']?.toString() ??
          json['referralCode']?.toString(),
      level: parseLevel(json['level']),
      referrals: parseReferrals(json['referrals']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'wallet': wallet,
        'referral_code': referralCode,
        'level': level,
        'referrals': referrals?.map((r) => r.toJson()).toList(),
      };

  String toRawJson() => jsonEncode(toJson());

  factory ReferralModel.fromRawJson(String str) =>
      ReferralModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
