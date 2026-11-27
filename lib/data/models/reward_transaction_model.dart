class RewardsTransactionModel {
  final String? points;
  final String? description;
  final String? type;
  final DateTime? createdAt;

  RewardsTransactionModel({
    this.points,
    this.description,
    this.type,
    this.createdAt,
  });

  factory RewardsTransactionModel.fromJson(Map<String, dynamic> json) =>
      RewardsTransactionModel(
        points: json["points"],
        description: json["description"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "points": points,
        "description": description,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
      };
  bool get isDebit => (type?.toLowerCase() == "debit");
}
