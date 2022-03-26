import 'dart:convert';

Bibliotheque bibliothequeFromJson(String str) =>
    Bibliotheque.fromJson(json.decode(str));
String bibliothequeToJson(Bibliotheque data) => json.encode(data.toJson());

class Bibliotheque {
  Bibliotheque({
    required this.numMus,
    required this.isbn,
    required this.dateAchat,
  });

  int numMus;
  String isbn;
  String dateAchat;

  factory Bibliotheque.fromJson(Map<String, dynamic> json) => Bibliotheque(
        numMus: json["numMus"],
        isbn: json["isbn"],
        dateAchat: json["dateAchat"],
      );

  Map<String, dynamic> toJson() => {
        "numMus": numMus,
        "isbn": isbn,
        "dateAchat": dateAchat,
      };
}
