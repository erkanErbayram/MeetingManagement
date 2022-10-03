import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:takvim_uygulamasi/Provider/api/abstract/order_api_interface.dart';

import 'package:takvim_uygulamasi/models/Order.dart';
import 'package:takvim_uygulamasi/models/ProductQuantity.dart';

class OrderApiClient extends OrderApiInterface {
  List<Order> _order;
  List<Order> _orderReport;

  static const baseUrl = "http://192.168.56.1:8081/api/order";
  Future getOrder(String getToken) async {
    final response =
        await http.get("$baseUrl/", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _order = jsonResponse.map((order) => Order.fromJson(order)).toList();

      return _order;
    }
  }

  Future getOrderReport(String getToken) async {
    final response = await http
        .get("$baseUrl/report", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _orderReport =
          jsonResponse.map((order) => Order.fromJson(order)).toList();

      return _orderReport;
    }
  }

  Future setOrder(String token, String meetingRoomName,
      List<ProductQuantity> product) async {
    List products = [];
    product.map((u) {
      products.add({"products": u.product, "quantity": u.quantity});
    }).toList();

    var body = jsonEncode({
      "meetingRoomName": meetingRoomName,
      "product": products,
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

  Future OrderDelivered(String getToken, String id, bool isDelivered) async {
    var body = jsonEncode({
      "isDelivered": isDelivered,
    });

    final response = await http.put("$baseUrl/delivered/$id",
        body: body,
        headers: {
          "x-access-token": getToken,
          "content-type": "application/json"
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
