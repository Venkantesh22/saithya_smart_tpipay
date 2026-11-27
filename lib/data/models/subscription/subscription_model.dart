import 'package:lekra/services/constants.dart';

class SubscriptionModel {
  final int? id;
  final int? membershipCategoryId;
  final String? name;
  final String? price;
  final String? timePeriods;
  final String? discountPrice;
  final List<String>? features;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionModel({
    this.id,
    this.membershipCategoryId,
    this.name,
    this.price,
    this.features,
    this.timePeriods,
    this.discountPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json["id"] is int ? json["id"] : int.tryParse('${json["id"]}'),
        membershipCategoryId: json["membership_category_id"] is int
            ? json["membership_category_id"]
            : (json["category_id"] is int
                ? json["category_id"]
                : int.tryParse('${json["membership_category_id"] ?? json["category_id"]}')),
        name: json["name"] != null ? capitalize(json["name"].toString()) : null,
        price: json["price"]?.toString(),
        timePeriods: (json["time_periods"] ?? json["validity_days"])?.toString(),
        discountPrice: (json["discount_price"] ?? json["price"])?.toString(),
        features: json["features"] == null
            ? []
            : List<String>.from((json["features"] as List).map((x) => x.toString())),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "membership_category_id": membershipCategoryId,
        "name": name,
        "price": price,
        "time_periods": timePeriods,
        "discount_price": discountPrice,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  String get priceFormat =>
      PriceConverter.convertToNumberFormat(double.tryParse(price ?? "0.0") ?? 0.0);

  String get discountPriceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse(discountPrice ?? "0.0") ?? 0.0);
}
