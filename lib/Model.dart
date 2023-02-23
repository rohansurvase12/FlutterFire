//
//     final basket = basketFromJson(jsonString);

import 'dart:convert';

Basket basketFromJson(String str) => Basket.fromJson(json.decode(str));

String basketToJson(Basket data) => json.encode(data.toJson());

class Basket {
  Basket({
    required this.id,
    required this.name,
    required this.quantity,
  });

  String id;
  String name;
  String quantity;

  factory Basket.fromJson(Map<String, dynamic> json) => Basket(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
      };
}
