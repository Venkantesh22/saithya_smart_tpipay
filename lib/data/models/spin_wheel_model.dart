class SpinWheelModel {
  final int? id;
  final String? offerName;
  final String? offerValue;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SpinWheelModel({
    this.id,
    this.offerName,
    this.offerValue,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory SpinWheelModel.fromJson(Map<String, dynamic> json) => SpinWheelModel(
        id: json["id"],
        offerName: json["offer_name"],
        offerValue: json["offer_value"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_name": offerName,
        "offer_value": offerValue,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  bool get isPoints => type == "points";
}
