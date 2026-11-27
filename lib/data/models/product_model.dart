import 'dart:convert';

import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';

class ProductModel {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final double? discountedPrice;
  final List<String>? features;
  final String? offers;
  final String? offerType;
  final String? priceCategory;
  final String? categoryName;
  final String? status;
  final String? videoUrl;
  final String? youtubeUrl;
  final String? instagramUrl;
  final String? facebookUrl;
  final String? whatsappUrl;
  final Map<String, dynamic>? socialLinks;
  final List<Image>? images;
  final double? distanceKm;
  final bool? isNearby;
  final bool? canDeliver;
  final String? deliveryType;
  final String? deliveryTime;
  final double? deliveryCharge;
  final String? vendorName;
  final String? vendorPincode;
  int? quantity;
  int? orderId;
  DateTime? createdAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountedPrice,
    this.features,
    this.offers,
    this.offerType,
    this.priceCategory,
    this.categoryName,
    this.status,
    this.videoUrl,
    this.youtubeUrl,
    this.instagramUrl,
    this.facebookUrl,
    this.whatsappUrl,
    this.socialLinks,
    this.images,
    this.distanceKm,
    this.isNearby,
    this.canDeliver,
    this.deliveryType,
    this.deliveryTime,
    this.deliveryCharge,
    this.vendorName,
    this.vendorPincode,
    this.quantity,
    this.orderId,
    this.createdAt,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],

        // FIX 1: Handle price safely (String OR Number)
        price: json["price"] == null
            ? null
            : double.tryParse(json["price"].toString().replaceAll(',', '')),

        // FIX 2: Handle discounted_price safely
        discountedPrice: json["discounted_price"] == null
            ? null
            : double.tryParse(
                json["discounted_price"].toString().replaceAll(',', '')),

        features: json["features"] == null
            ? []
            : List<String>.from(json["features"]!.map((x) => x)),
        offers:
            json["offers"]?.toString(), // Safely convert to string if needed
        offerType: json["offer_type"],
        priceCategory: json["price_category"],
        // Added null check for category_name to avoid crash if null
        categoryName: json["category_name"] != null
            ? capitalize(json["category_name"])
            : null,
        status: json["status"]?.toString(),
        videoUrl: json["video_url"]?.toString(),
        youtubeUrl: json["youtube_url"]?.toString() ??
            (json["social_links"] is Map ? json["social_links"]["youtube"]?.toString() : null),
        instagramUrl: json["instagram_url"]?.toString() ??
            (json["social_links"] is Map ? json["social_links"]["instagram"]?.toString() : null),
        facebookUrl: json["facebook_url"]?.toString() ??
            (json["social_links"] is Map ? json["social_links"]["facebook"]?.toString() : null),
        whatsappUrl: json["whatsapp_url"]?.toString() ??
            (json["social_links"] is Map ? json["social_links"]["whatsapp"]?.toString() : null),
        socialLinks: (json["social_links"] is Map)
            ? Map<String, dynamic>.from(json["social_links"])
            : null,
        images: json["images"] == null
            ? []
            : (json["images"] is List)
                ? (json["images"] as List)
                    .map((x) => Image.fromJson(x))
                    .toList()
                : [],
        quantity: json["quantity"] is int
            ? json["quantity"]
            : int.tryParse(json["quantity"]?.toString() ?? '1'),
        orderId: json["order_id"] is int
            ? json["order_id"]
            : int.tryParse(json["order_id"]?.toString() ?? '0'),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
        distanceKm: json["distance_km"] != null ? double.tryParse(json["distance_km"].toString()) : null,
        isNearby: json["is_nearby"] is bool ? json["is_nearby"] : (json["is_nearby"] == 1 || json["is_nearby"] == '1'),
        canDeliver: json["can_deliver"] is bool ? json["can_deliver"] : (json["can_deliver"] == 1 || json["can_deliver"] == '1'),
        deliveryType: json["delivery_type"]?.toString(),
        deliveryTime: json["delivery_time"]?.toString(),
        deliveryCharge: json["delivery_charge"] != null ? double.tryParse(json["delivery_charge"].toString()) : null,
        vendorName: json["vendor_name"]?.toString(),
        vendorPincode: json["vendor_pincode"]?.toString(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "discounted_price": discountedPrice,
        "features":
            features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
        "offers": offers,
        "offer_type": offerType,
        "price_category": priceCategory,
        "status": status,
        "video_url": videoUrl,
        "youtube_url": youtubeUrl,
        "instagram_url": instagramUrl,
        "facebook_url": facebookUrl,
        "whatsapp_url": whatsappUrl,
        "social_links": socialLinks,
        "quantity": quantity,
        "order_id": orderId,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
      };

  // ✅ Formatters for display
  String get priceFormat => PriceConverter.convertToNumberFormat(price ?? 0.0);

  String get discountedPriceFormat =>
      PriceConverter.convertToNumberFormat(discountedPrice ?? price ?? 0.0);

  String get offersFormat {
    if (offers == null || offers!.isEmpty) return "";
    if (offerType == "percentage") {
      return "$offers OFF";
    } else {
      return offers ?? "";
    }
  }

  String? get orderStatus => status == "pending"
      ? Assets.imagesOrderStatusConfirmed
      : status == "processing"
          ? Assets.imagesOrderStatusConfirmed
          : status == "shipped"
              ? Assets.imagesOrderStatusShipping
              : status == "delivered"
                  ? Assets.imagesOrderStatusDelivered
                  : status == "cancelled"
                      ? Assets.imagesOrderStatusCancel
                      : null;
}

class Image {
  final int? id;
  final String? url;

  Image({
    this.id,
    this.url,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(dynamic json) {
    if (json is String) {
      return Image(id: 1, url: json);
    }
    if (json is Map) {
      return Image(
        id: json["id"] is int
            ? json["id"] as int
            : int.tryParse(json["id"]?.toString() ?? '1'),
        url: json["url"]?.toString() ?? json["image_url"]?.toString() ?? '',
      );
    }
    return Image(id: 1, url: json?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
