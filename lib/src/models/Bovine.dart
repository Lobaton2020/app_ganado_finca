import 'dart:convert';

List<Bovine> bovineFromJson(String str) => List<Bovine>.from(json.decode(str).map((x) => Bovine.fromJson(x)));

String bovineToJson(List<Bovine> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bovine {
    int id;
    String createdAt;
    String name;
    DateTime dateBirth;
    String color;
    int ownerId;
    dynamic photo;
    int? motherId;
    bool isMale;
    bool forIncrease;
    dynamic adquisitionAmount;
    int provenanceId;

    Bovine({
        required this.id,
        required this.createdAt,
        required this.name,
        required this.dateBirth,
        required this.color,
        required this.ownerId,
        required this.photo,
        required this.motherId,
        required this.isMale,
        required this.forIncrease,
        required this.adquisitionAmount,
        required this.provenanceId,
    });

    factory Bovine.fromJson(Map<String, dynamic> json) => Bovine(
        id: json["id"],
        createdAt: json["created_at"],
        name: json["name"],
        dateBirth: DateTime.parse(json["date_birth"]),
        color: json["color"],
        ownerId: json["owner_id"],
        photo: json["photo"],
        motherId: json["mother_id"],
        isMale: json["is_male"],
        forIncrease: json["for_increase"],
        adquisitionAmount: json["adquisition_amount"],
        provenanceId: json["provenance_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "name": name,
        "date_birth": "${dateBirth.year.toString().padLeft(4, '0')}-${dateBirth.month.toString().padLeft(2, '0')}-${dateBirth.day.toString().padLeft(2, '0')}",
        "color": color,
        "owner_id": ownerId,
        "photo": photo,
        "mother_id": motherId,
        "is_male": isMale,
        "for_increase": forIncrease,
        "adquisition_amount": adquisitionAmount,
        "provenance_id": provenanceId,
    };
}
