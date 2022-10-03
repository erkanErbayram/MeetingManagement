import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/order_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/order_api_interface.dart';

import 'package:takvim_uygulamasi/locator.dart';

import 'package:takvim_uygulamasi/models/Order.dart';
import 'package:takvim_uygulamasi/models/ProductQuantity.dart';

enum OrderState {
  InitialOrderState,
  OrderLoadingState,
  OrderLoaded,
  OrderErrorState,
}

class OrderViewModel extends OrderViewInterface with ChangeNotifier {
  OrderApiInterface _orderApi = locator<OrderApiInterface>();
  OrderState _state;
  List<Order> _order;
  List<Order> _orderReport;
  bool result;
  bool _isDelivered;
  List<Order> get getOrderList => _order;
  List<Order> get getOrderReportList => _orderReport;
  OrderState get state => _state;
  bool get isDelivered => _isDelivered;
  set state(OrderState value) {
    _state = value;
    notifyListeners();
  }

  OrderViewModel() {
    _order = List<Order>();
    _orderReport = List<Order>();
  }

  Future<List<Order>> getOrder(String getToken) async {
    try {
      state = OrderState.OrderLoadingState;
      _order = await _orderApi.getOrder(getToken);
      state = OrderState.OrderLoaded;
      return _order;
    } catch (e) {
      print(e);
      state = OrderState.OrderErrorState;
    }
  }

  Future<List<Order>> getOrderReport(String getToken) async {
    try {
      state = OrderState.OrderLoadingState;
      _order = await _orderApi.getOrderReport(getToken);
      state = OrderState.OrderLoaded;
      return _order;
    } catch (e) {
      print(e);
      state = OrderState.OrderErrorState;
    }
  }

  Future setOrder(String token, String meetingRoomName,
      List<ProductQuantity> product) async {
    try {
      result = await _orderApi.setOrder(token, meetingRoomName, product);
    } catch (err) {
      print(err);
    }
  }

  Future orderDelivered(String getToken, String id, bool isDelivered) async {
    try {
      _isDelivered = await _orderApi.OrderDelivered(getToken, id, isDelivered);
    } catch (err) {
      print(err);
    }
  }
}
