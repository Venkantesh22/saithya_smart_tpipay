import 'package:lekra/services/constants.dart';

class RechargePlanResponse {
  final bool? success;
  final String? operatorCode;
  final String? circleCode;
  final Map<String, List<RechargePlan>>? plans;

  RechargePlanResponse({
    this.success,
    this.operatorCode,
    this.circleCode,
    this.plans,
  });

  factory RechargePlanResponse.fromJson(Map<String, dynamic> json) {
    Map<String, List<RechargePlan>> parsedPlans = {};

    if (json['plans'] != null) {
      json['plans'].forEach((key, value) {
        parsedPlans[key] = List<RechargePlan>.from(
          value.map((x) => RechargePlan.fromJson(x)),
        );
      });
    }

    return RechargePlanResponse(
      success: json['success'],
      operatorCode: json['operator_code'],
      circleCode: json['circle_code'],
      plans: parsedPlans,
    );
  }
}

class RechargePlan {
  final String? rs;
  final String? desc;
  final String? validity;
  final String? lastUpdate;

  RechargePlan({
    this.rs,
    this.desc,
    this.validity,
    this.lastUpdate,
  });

  factory RechargePlan.fromJson(Map<String, dynamic> json) {
    return RechargePlan(
      rs: json['rs']?.toString(),
      desc: json['desc'].toString().replaceAll("Benefits: ", ""),
      validity: json['validity']?.toString(),
      lastUpdate: json['last_update'],
    );
  }

  String get planAmount =>
      PriceConverter.convertToNumberFormat(double.tryParse(rs ?? "0.0") ?? 0.0);
}
