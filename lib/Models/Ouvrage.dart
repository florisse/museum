import 'dart:convert';

Ouvrage ouvrageFromJson(String str) => Ouvrage.fromJson(json.decode(str));
String ouvrageToJson(Ouvrage data) => json.encode(data.toJson());

class Ouvrage {
  Ouvrage({
    required this.isbn,
    required this.nbPage,
    required this.titre,
    required this.codePays,
  });

  String isbn;
  int nbPage;
  String titre;
  String codePays;

  factory Ouvrage.fromJson(Map<String, dynamic> json) => Ouvrage(
        isbn: json["isbn"],
        nbPage: json["nbPage"],
        titre: json["titre"],
        codePays: json["codePays"],
      );

  Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "nbPage": nbPage,
        "titre": titre,
        "codePays": codePays,
      };
}
