import 'dart:convert';

BovineOutput bovineOutputFromJson(String str) =>
    BovineOutput.fromJson(json.decode(str));

String bovineOutputToJson(BovineOutput data) => json.encode(data.toJson());

class BovineOutput {
  int? id;
  DateTime createdAt;
  bool wasSold;
  int? soldAmount;
  String? description;
  int bovineId;
  String? photo;
  String? name;

  BovineOutput(
      {required this.id,
      required this.createdAt,
      required this.wasSold,
      required this.soldAmount,
      required this.description,
      required this.bovineId,
      required this.photo,
      required this.name});

  factory BovineOutput.fromJson(Map<String, dynamic> json) => BovineOutput(
      id: json["id"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
      wasSold: json["was_sold"],
      soldAmount: json["sold_amount"],
      description: json["description"],
      bovineId: json["bovine_id"],
      photo: json["photo"],
      name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "was_sold": wasSold,
        "sold_amount": soldAmount,
        "description": description,
        "bovine_id": bovineId,
        "photo": photo,
        "name": name
      };
}
