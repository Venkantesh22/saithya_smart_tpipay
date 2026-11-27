import 'dart:convert';

class CategoryModel {
  int? id;
  String? name;
  String? icon;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
