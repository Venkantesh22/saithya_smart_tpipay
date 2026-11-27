import 'package:lekra/data/models/subscription_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';

class SubscriptionHistoryModel {
  final int? subscriptionId;
  final int? planId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? status;
  final String? planName;
  final String? price;
  final String? discountPrice;
  final String? pricePaid;
  final String? paymentReference;
  final String? paymentStatus;
  final DateTime? createdAt;
  final int? totalDays;
  final int? usedDays;
  final int? remainingDays;
  final int? freeDeliveryCount;
  final double? maxShippingSubsidy;
  final double? minOrderValue;
  final double? giftWalletAmount;
  final double? packageValue;
  final double? scratchCardValue;
  final double? scratchCardPrice;
  final bool? hasFreeDelivery;
  final String? validityLabel;
  final List<String> features;
  final SubscriptionModel? plan;

  SubscriptionHistoryModel({
    this.subscriptionId,
    this.planId,
    this.startDate,
    this.endDate,
    this.status,
    this.planName,
    this.price,
    this.discountPrice,
    this.pricePaid,
    this.paymentReference,
    this.paymentStatus,
    this.createdAt,
    this.totalDays,
    this.usedDays,
    this.remainingDays,
    this.freeDeliveryCount,
    this.maxShippingSubsidy,
    this.minOrderValue,
    this.giftWalletAmount,
    this.packageValue,
    this.scratchCardValue,
    this.scratchCardPrice,
    this.hasFreeDelivery,
    this.validityLabel,
    this.features = const [],
    this.plan,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    int? parseStatus(dynamic val) {
      if (val is int) return val;
      if (val is bool) return val ? 1 : 0;
      if (val == null) return 0;
      final str = val.toString().toLowerCase();
      if (str == 'active' || str == '1' || str == 'true' || str == 'completed') return 1;
      return 0;
    }

    final rawPlan = (json["plan"] != null && json["plan"] is Map<String, dynamic>)
        ? (json["plan"] as Map<String, dynamic>)
        : null;

    final parsedPlanPrice = double.tryParse('${rawPlan?["price"]}') ?? 0.0;
    final parsedPrice = double.tryParse('${json["price"]}') ?? 0.0;
    final parsedPaid = double.tryParse('${json["price_paid"] ?? json["discount_price"] ?? rawPlan?["discount_price"]}') ?? 0.0;

    // Pick highest value between rawPlan["price"] and json["price"] for the original MRP
    final effectivePrice = (parsedPlanPrice > 0 && parsedPlanPrice > parsedPrice)
        ? parsedPlanPrice.toStringAsFixed(2)
        : (parsedPrice > 0 ? parsedPrice.toStringAsFixed(2) : (parsedPaid > 0 ? parsedPaid.toStringAsFixed(2) : "0.00"));

    final effectiveDiscountPrice = (json["discount_price"] ?? rawPlan?["discount_price"] ?? json["price_paid"] ?? effectivePrice)?.toString();
    final effectivePaid = (json["price_paid"] ?? json["discount_price"] ?? rawPlan?["discount_price"] ?? effectivePrice)?.toString();

    // Features parsing
    List<String> parsedFeatures = [];
    if (json["features"] is List) {
      parsedFeatures = List<String>.from((json["features"] as List).map((x) => x.toString()));
    } else if (rawPlan != null && rawPlan["features"] is List) {
      parsedFeatures = List<String>.from((rawPlan["features"] as List).map((x) => x.toString()));
    }

    final parsedDeliveryCount = json["free_delivery_count"] is int
        ? json["free_delivery_count"]
        : (rawPlan?["free_delivery_count"] is int
            ? rawPlan!["free_delivery_count"]
            : int.tryParse('${json["free_delivery_count"] ?? rawPlan?["free_delivery_count"] ?? 0}'));

    final parsedSubsidy = double.tryParse('${json["max_shipping_subsidy"] ?? rawPlan?["max_shipping_subsidy"] ?? 0}');
    final parsedMinOrder = double.tryParse('${json["min_order_value"] ?? rawPlan?["min_order_value"] ?? 0}');
    final parsedGift = double.tryParse('${json["gift_wallet_amount"] ?? rawPlan?["gift_wallet_amount"] ?? 0}');

    return SubscriptionHistoryModel(
      subscriptionId: json["subscription_id"] is int
          ? json["subscription_id"]
          : int.tryParse('${json["subscription_id"] ?? json["id"]}'),
      planId: json["plan_id"] is int
          ? json["plan_id"]
          : (rawPlan?["id"] is int
              ? rawPlan!["id"]
              : int.tryParse('${json["plan_id"] ?? rawPlan?["id"]}')),
      startDate: json["start_date"] == null
          ? null
          : DateTime.tryParse(json["start_date"].toString()),
      endDate: json["end_date"] == null
          ? null
          : DateTime.tryParse(json["end_date"].toString()),
      status: parseStatus(json["status"]),
      planName: (json["plan_name"] ?? rawPlan?["name"])?.toString(),
      price: effectivePrice,
      discountPrice: effectiveDiscountPrice,
      pricePaid: effectivePaid,
      paymentReference: (json["payment_reference"] ?? json["transaction_id"] ?? json["payment_ref"])?.toString(),
      paymentStatus: (json["payment_status"] ?? (parseStatus(json["status"]) == 1 ? "Paid" : "Completed"))?.toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"].toString()),
      totalDays: json["total_days"] is int
          ? json["total_days"]
          : int.tryParse('${json["total_days"]}'),
      usedDays: json["used_days"] is int
          ? json["used_days"]
          : int.tryParse('${json["used_days"]}'),
      remainingDays: json["remaining_days"] is int
          ? json["remaining_days"]
          : int.tryParse('${json["remaining_days"]}'),
      freeDeliveryCount: parsedDeliveryCount,
      maxShippingSubsidy: parsedSubsidy,
      minOrderValue: parsedMinOrder,
      giftWalletAmount: parsedGift,
      packageValue: double.tryParse('${json["package_value"] ?? rawPlan?["package_value"] ?? 0}'),
      scratchCardValue: double.tryParse('${json["scratch_card_value"] ?? rawPlan?["scratch_card_value"] ?? 0}'),
      scratchCardPrice: double.tryParse('${json["scratch_card_price"] ?? rawPlan?["scratch_card_price"] ?? 0}'),
      hasFreeDelivery: json["has_free_delivery"] is bool
          ? json["has_free_delivery"]
          : (json["has_free_delivery"] == 1 || json["has_free_delivery"] == '1' || json["has_free_delivery"] == 'true' || rawPlan?["has_free_delivery"] == true),
      validityLabel: (json["validity_label"] ?? rawPlan?["validity_label"])?.toString(),
      features: parsedFeatures,
      plan: rawPlan != null ? SubscriptionModel.fromJson(rawPlan) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "plan_id": planId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "status": status,
        "plan_name": planName,
        "price": price,
        "discount_price": discountPrice,
        "price_paid": pricePaid,
        "payment_reference": paymentReference,
        "payment_status": paymentStatus,
        "created_at": createdAt?.toIso8601String(),
        "total_days": totalDays,
        "used_days": usedDays,
        "remaining_days": remainingDays,
        "free_delivery_count": freeDeliveryCount,
        "max_shipping_subsidy": maxShippingSubsidy,
        "min_order_value": minOrderValue,
        "gift_wallet_amount": giftWalletAmount,
        "features": features,
        "plan": plan?.toJson(),
      };

  bool get isActive => (remainingDays ?? 0) > 0 || status == 1;

  String get effectivePlanName => (planName?.isNotEmpty == true) ? planName! : "VIP Membership Pass";

  double get originalPriceValue => double.tryParse(price ?? "0.0") ?? 0.0;
  double get paidPriceValue => double.tryParse(pricePaid ?? discountPrice ?? price ?? "0.0") ?? 0.0;
  double get discountAmount => (originalPriceValue > paidPriceValue) ? (originalPriceValue - paidPriceValue) : 0.0;
  bool get hasDiscount => discountAmount > 0;

  String get priceFormat =>
      PriceConverter.convertToNumberFormat(originalPriceValue);

  String get discountPriceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse(discountPrice ?? "") ?? 0.0);

  String get pricePaidFormat =>
      PriceConverter.convertToNumberFormat(paidPriceValue);

  String get discountAmountFormat =>
      PriceConverter.convertToNumberFormat(discountAmount);

  String get startDateFormat =>
      DateFormatters().dMyDash2.format(startDate ?? getDateTime());

  String get endDateFormat =>
      DateFormatters().dMyDash2.format(endDate ?? getDateTime());

  String get createdDateFormat =>
      DateFormatters().dMonthYear.format(createdAt ?? startDate ?? getDateTime());
}
