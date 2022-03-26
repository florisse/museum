import 'dart:convert';

Moment momentFromJson(String str) => Moment.fromJson(json.decode(str));
String momentToJson(Moment data) => json.encode(data.toJson());

class Moment {
  Moment({
    required this.jour,
  });

  String jour;

  factory Moment.fromJson(Map<String, dynamic> json) => Moment(
        jour: json["jour"],
      );

  Map<String, dynamic> toJson() => {
        "jour": jour,
      };
}
