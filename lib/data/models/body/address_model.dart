class AddressModel {
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? type;
  String? street;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  double? latitude;
  double? longitude;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.type,
    this.street,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        phone: json["phone"],
        type: json["type"] ?? json["address_type"] ?? "home",
        street: json["street"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        latitude: json["latitude"] != null ? double.tryParse(json["latitude"].toString()) : null,
        longitude: json["longitude"] != null ? double.tryParse(json["longitude"].toString()) : null,
        isDefault: json["is_default"] == true || json["is_default"] == 1,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "phone": phone,
        "type": type,
        "street": street,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  String get fullAddress {
    final parts = [
      street,
      if (landmark != null && landmark!.isNotEmpty) landmark,
      city,
      state != null && pincode != null ? "$state - $pincode" : (state ?? pincode),
    ].where((e) => e != null && e.toString().trim().isNotEmpty).toList();
    return parts.join(", ");
  }

  String get displayType {
    final t = (type ?? 'home').toLowerCase();
    if (t == 'office') return 'Office';
    if (t == 'other') return 'Other';
    return 'Home';
  }
}
