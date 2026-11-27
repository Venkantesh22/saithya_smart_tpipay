import 'package:lekra/services/constants.dart';

class SubscriptionModel {
  final int? id;
  final int? membershipCategoryId;
  final String? name;
  final String? price;
  final String? timePeriods;
  final String? discountPrice;
  final List<String> features;
  final int? freeDeliveryCount;
  final double? maxShippingSubsidy;
  final double? minOrderValue;
  final double? giftWalletAmount;
  final double? packageValue;
  final double? scratchCardValue;
  final double? scratchCardPrice;
  final bool? hasFreeDelivery;
  final String? validityType;
  final double? validityUnitValue;
  final String? validityLabelText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionModel({
    this.id,
    this.membershipCategoryId,
    this.name,
    this.price,
    this.features = const [],
    this.timePeriods,
    this.discountPrice,
    this.freeDeliveryCount,
    this.maxShippingSubsidy,
    this.minOrderValue,
    this.giftWalletAmount,
    this.packageValue,
    this.scratchCardValue,
    this.scratchCardPrice,
    this.hasFreeDelivery,
    this.validityType,
    this.validityUnitValue,
    this.validityLabelText,
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
        freeDeliveryCount: json["free_delivery_count"] is int
            ? json["free_delivery_count"]
            : int.tryParse('${json["free_delivery_count"] ?? 0}'),
        maxShippingSubsidy: double.tryParse('${json["max_shipping_subsidy"] ?? 0}'),
        minOrderValue: double.tryParse('${json["min_order_value"] ?? 0}'),
        giftWalletAmount: double.tryParse('${json["gift_wallet_amount"] ?? 0}'),
        packageValue: double.tryParse('${json["package_value"] ?? 0}'),
        scratchCardValue: double.tryParse('${json["scratch_card_value"] ?? 0}'),
        scratchCardPrice: double.tryParse('${json["scratch_card_price"] ?? 0}'),
        hasFreeDelivery: json["has_free_delivery"] is bool
            ? json["has_free_delivery"]
            : (json["has_free_delivery"] == 1 || json["has_free_delivery"] == '1' || json["has_free_delivery"] == 'true'),
        validityType: json["validity_type"]?.toString(),
        validityUnitValue: double.tryParse('${json["validity_unit_value"] ?? 0}'),
        validityLabelText: json["validity_label"]?.toString(),
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
        "features": List<dynamic>.from(features.map((x) => x)),
        "free_delivery_count": freeDeliveryCount,
        "max_shipping_subsidy": maxShippingSubsidy,
        "min_order_value": minOrderValue,
        "gift_wallet_amount": giftWalletAmount,
        "package_value": packageValue,
        "scratch_card_value": scratchCardValue,
        "scratch_card_price": scratchCardPrice,
        "has_free_delivery": hasFreeDelivery,
        "validity_type": validityType,
        "validity_unit_value": validityUnitValue,
        "validity_label": validityLabelText,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  double get originalPriceValue => double.tryParse(price ?? "0.0") ?? 0.0;
  double get discountPriceValue => double.tryParse(discountPrice ?? price ?? "0.0") ?? 0.0;
  double get discountAmount => (originalPriceValue > discountPriceValue) ? (originalPriceValue - discountPriceValue) : 0.0;
  bool get hasDiscount => discountAmount > 0;

  String get priceFormat =>
      PriceConverter.convertToNumberFormat(originalPriceValue);

  String get discountPriceFormat =>
      PriceConverter.convertToNumberFormat(discountPriceValue);

  String get discountAmountFormat =>
      PriceConverter.convertToNumberFormat(discountAmount);

  String get validityLabel {
    if (validityLabelText != null && validityLabelText!.isNotEmpty) {
      return validityLabelText!;
    }
    final days = int.tryParse(timePeriods ?? "30") ?? 30;
    if (days >= 365 && days % 365 == 0) {
      final years = (days / 365).round();
      return "$days Days ($years Year${years > 1 ? 's' : ''})";
    } else if (days >= 365) {
      final years = (days / 365).toStringAsFixed(1);
      return "$days Days ($years Years)";
    }
    return "$days Days";
  }
}
