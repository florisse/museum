import 'dart:convert';

Visiter visiterFromJson(String str) => Visiter.fromJson(json.decode(str));
String visiterToJson(Visiter data) => json.encode(data.toJson());

class Visiter {
  Visiter({
    required this.numMus,
    required this.jour,
    required this.nbvisiteurs,
  });

  int numMus;
  String jour;
  int nbvisiteurs;

  factory Visiter.fromJson(Map<String, dynamic> json) => Visiter(
        numMus: json["numMus"],
        jour: json["jour"],
        nbvisiteurs: json["nbvisiteurs"],
      );

  Map<String, dynamic> toJson() => {
        "numMus": numMus,
        "jour": jour,
        "nbvisiteurs": nbvisiteurs,
      };
}
