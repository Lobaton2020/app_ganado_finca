import 'dart:convert';

ResumeGeneric resumeTotalFromJson(String str) =>
    ResumeGeneric.fromJson(json.decode(str));

String resumeTotalToJson(ResumeGeneric data) => json.encode(data.toJson());

class ResumeGeneric {
  String? name;
  String type;
  double sum;
  int count;

  ResumeGeneric({
    this.name,
    required this.type,
    required this.sum,
    required this.count,
  });

  factory ResumeGeneric.fromJson(Map<String, dynamic> json) => ResumeGeneric(
        name: json["name"],
        type: json["type"],
        sum: json["sum"]?.toDouble(),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "sum": sum,
        "count": count,
      };
}
