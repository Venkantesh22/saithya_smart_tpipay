import 'dart:convert';

class BannerModel {
  final int? id;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    this.id,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromRawJson(String str) =>
      BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
