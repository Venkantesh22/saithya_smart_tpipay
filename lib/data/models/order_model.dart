import 'package:lekra/data/models/body/address_model.dart';
import 'package:lekra/data/models/product_model.dart';

class OrderModel {
  final int? id;
  int? addressId;
  final double? subtotal;
  final double? totalPrice;
  final double? discount;
  String? status;
  final String? paymentStatus;
  String? billingName;
  String? billingPhone;
  String? billingEmail;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<ProductModel>? products;
  final AddressModel? address;

  OrderModel({
    this.id,
    this.addressId,
    this.subtotal,
    this.totalPrice,
    this.discount,
    this.status,
    this.paymentStatus,
    this.billingName,
    this.billingPhone,
    this.billingEmail,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        addressId: json["address_id"],
        subtotal: json["subtotal"] == null
            ? null
            : double.tryParse(json["subtotal"].toString().replaceAll(',', '')),
        totalPrice: json["total_price"] == null
            ? null
            : double.tryParse(json["total_price"].toString().replaceAll(',', '')),
        discount: json["discount"] == null
            ? null
            : double.tryParse(json["discount"].toString().replaceAll(',', '')),
        status: json["status"] ?? json["order_status"],
        paymentStatus: json["payment_status"],
        billingName: json["billing_name"],
        billingPhone: json["billing_phone"],
        billingEmail: json["billing_email"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        products: json["products"] == null
            ? []
            : List<ProductModel>.from(
                json["products"]!.map((x) => ProductModel.fromJson(x))),
        address: json["address"] == null
            ? null
            : AddressModel.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_id": addressId,
        "subtotal": subtotal,
        "total_price": totalPrice,
        "discount": discount,
        "status": status,
        "payment_status": paymentStatus,
        "billing_name": billingName,
        "billing_phone": billingPhone,
        "billing_email": billingEmail,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
