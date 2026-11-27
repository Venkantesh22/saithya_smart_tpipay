class SupportModel {
  final int? id;
  final String? mobile;
  final String? email;
  final String? whatsapp;
  final String? hours;
  final String? address;

  SupportModel({
    this.id,
    this.mobile,
    this.email,
    this.whatsapp,
    this.hours,
    this.address,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
        id: json["id"] is int ? json["id"] : int.tryParse('${json["id"]}'),
        mobile: json["mobile"]?.toString(),
        email: json["email"]?.toString(),
        whatsapp: json["whatsapp"]?.toString(),
        hours: (json["hours"] ?? json["working_hours"])?.toString(),
        address: json["address"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile": mobile,
        "email": email,
        "whatsapp": whatsapp,
        "hours": hours,
        "address": address,
      };
}
