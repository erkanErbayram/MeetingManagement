import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:takvim_uygulamasi/Provider/api/abstract/product_api_interface.dart';
import 'package:takvim_uygulamasi/models/Product.dart';

class ProductApiClient extends ProductApiInterface {
  List<Product> _product;

  static const baseUrl = "http://192.168.56.1:8081/api/product";
  Future getProduct(String getToken) async {
    final response =
        await http.get("$baseUrl/", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _product =
          jsonResponse.map((product) => Product.fromJson(product)).toList();

      return _product;
    }
  }

  Future setProduct(
      String token, String productName, int productPrice, int stock) async {
    var body = jsonEncode({
      "productName": productName,
      "productPrice": productPrice,
      "stock": stock
    });

    final response = await http.post("$baseUrl/",
        body: body,
        headers: {"x-access-token": token, "content-type": "application/json"});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
