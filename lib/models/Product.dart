// To parse this JSON data, do
//
//     final urunler = urunlerFromJson(jsonString);

import 'dart:convert';

Product productlerFromJson(String str) => Product.fromJson(json.decode(str));

String productlerToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.productPrice,
    this.stock,
    this.id,
    this.companies,
    this.productName,
    this.v,
  });

  int productPrice;
  int stock;
  String id;
  String companies;
  String productName;
  int v;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productPrice:
            json["productPrice"] == null ? null : json["productPrice"],
        stock: json["stock"] == null ? null : json["stock"],
        id: json["_id"] == null ? null : json["_id"],
        companies: json["companies"] == null ? null : json["companies"],
        productName: json["productName"] == null ? null : json["productName"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice == null ? null : productPrice,
        "stock": stock == null ? null : stock,
        "_id": id == null ? null : id,
        "companies": companies == null ? null : companies,
        "productName": productName == null ? null : productName,
        "__v": v == null ? null : v,
      };
}
