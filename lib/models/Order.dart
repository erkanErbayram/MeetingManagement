// To parse this JSON data, do
//
//     final Order = OrderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    this.isDelivered,
    this.id,
    this.companies,
    this.product,
    this.meetingRoom,
    this.user,
    this.orderDate,
    this.v,
  });

  bool isDelivered;
  String id;
  String companies;
  List<Product> product;
  String meetingRoom;
  User user;
  DateTime orderDate;
  int v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        isDelivered: json["isDelivered"] == null ? null : json["isDelivered"],
        id: json["_id"] == null ? null : json["_id"],
        companies: json["companies"] == null ? null : json["companies"],
        product: json["product"] == null
            ? null
            : List<Product>.from(
                json["product"].map((x) => Product.fromJson(x))),
        meetingRoom: json["meetingRoom"] == null ? null : json["meetingRoom"],
        user: json["User"] == null ? null : User.fromJson(json["User"]),
        orderDate: json["orderDate"] == null
            ? null
            : DateTime.parse(json["orderDate"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "isDelivered": isDelivered == null ? null : isDelivered,
        "_id": id == null ? null : id,
        "companies": companies == null ? null : companies,
        "product": product == null
            ? null
            : List<dynamic>.from(product.map((x) => x.toJson())),
        "meetingRoom": meetingRoom == null ? null : meetingRoom,
        "User": User == null ? null : user.toJson(),
        "orderDate": orderDate == null ? null : orderDate.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class User {
  User({
    this.id,
    this.nameSurname,
    this.email,
  });

  String id;
  String nameSurname;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        nameSurname: json["nameSurname"] == null ? null : json["nameSurname"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "nameSurname": nameSurname == null ? null : nameSurname,
        "email": email == null ? null : email,
      };
}

class Product {
  Product({
    this.quantity,
    this.id,
    this.products,
  });

  int quantity;
  String id;
  Products products;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        quantity: json["quantity"] == null ? null : json["quantity"],
        id: json["_id"] == null ? null : json["_id"],
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity == null ? null : quantity,
        "_id": id == null ? null : id,
        "products": products == null ? null : products.toJson(),
      };
}

class Products {
  Products({
    this.id,
    this.productName,
  });

  String id;
  String productName;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["_id"] == null ? null : json["_id"],
        productName: json["productName"] == null ? null : json["productName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "productName": productName == null ? null : productName,
      };
}
