import 'dart:convert';

Pays paysFromJson(String str) => Pays.fromJson(json.decode(str));
String paysToJson(Pays data) => json.encode(data.toJson());

class Pays {
  Pays({
    required this.codePays,
    required this.nbhabitant,
  });

  String codePays;
  int nbhabitant;

  factory Pays.fromJson(Map<String, dynamic> json) => Pays(
        codePays: json["codePays"],
        nbhabitant: json["nbhabitant"],
      );

  Map<String, dynamic> toJson() => {
        "codePays": codePays,
        "nbhabitant": nbhabitant,
      };
}
