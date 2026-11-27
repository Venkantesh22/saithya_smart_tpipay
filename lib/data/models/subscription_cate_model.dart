
class SubscriptionCategoryModel {
    final int? id;
    final String? name;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    SubscriptionCategoryModel({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
    });

    factory SubscriptionCategoryModel.fromJson(Map<String, dynamic> json) => SubscriptionCategoryModel(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
