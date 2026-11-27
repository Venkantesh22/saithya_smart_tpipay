import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';

class CardModel {
  List<ProductModel>? products;
  int? cartId;
  String? subtotal;
  String? productDiscount;
  String? totalPrice;
  final String? couponType;
  final String? couponValue;
  final String? couponDiscount;
  final int? rewardPointsUsed;
  final int? rewardPointsBalance;
  final String? rewardDiscount;

  CardModel({
    this.products,
    this.cartId,
    this.subtotal,
    this.productDiscount,
    this.totalPrice,
    this.couponDiscount,
    this.couponType,
    this.couponValue,
    this.rewardPointsUsed,
    this.rewardPointsBalance,
    this.rewardDiscount,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    var rawProducts = json["products"] ?? json["items"];
    List<ProductModel> productList = [];
    if (rawProducts is List) {
      productList = rawProducts
          .map((x) => ProductModel.fromJson(Map<String, dynamic>.from(x)))
          .toList();
    }

    return CardModel(
        cartId: json["cart_id"] is int
            ? json["cart_id"]
            : int.tryParse(json["cart_id"]?.toString() ?? '1'),
        products: productList,
        subtotal: json["subtotal"]?.toString(),
        productDiscount: json["product_discount"]?.toString() ?? "0.00",
        totalPrice: json["total_price"]?.toString() ?? json["subtotal"]?.toString(),
        couponType: json["coupon_type"]?.toString(),
        couponValue: json["coupon_value"]?.toString(),
        couponDiscount: json["coupon_discount"]?.toString(),
        rewardPointsUsed: json["reward_points_used"] is int
            ? json["reward_points_used"]
            : int.tryParse(json["reward_points_used"]?.toString() ?? "0"),
        rewardPointsBalance: int.tryParse(
          json["reward_points_balance"]?.toString() ?? "0",
        ),
        rewardDiscount: json["reward_discount"]?.toString(),
      );
  }

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "subtotal": subtotal,
        "product_discount": productDiscount,
        "total_price": totalPrice,
        "coupon_discount": couponDiscount,
        "coupon_type": couponType,
        "coupon_value": couponValue,
        "reward_points_used": rewardPointsUsed,
        "reward_points_balance": rewardPointsBalance,
        "reward_discount": rewardDiscount,
      };

  String get totalPriceFormat => PriceConverter.convertToNumberFormat(
      double.tryParse(totalPrice ?? "0") ?? 0.0);

  String get discountFormat => PriceConverter.convertToNumberFormat(
      double.tryParse(productDiscount ?? "0") ?? 0.0);

  String get subtotalFormat => PriceConverter.convertToNumberFormat(
      double.tryParse(subtotal ?? "0") ?? 0.0);

  String get couponDiscountFormat => PriceConverter.convertToNumberFormat(
        double.tryParse(couponDiscount ?? "0") ?? 0.0,
      );
  String get rewardDiscountFormat => PriceConverter.convertToNumberFormat(
        double.tryParse(rewardDiscount ?? "0") ?? 0.0,
      );
}
