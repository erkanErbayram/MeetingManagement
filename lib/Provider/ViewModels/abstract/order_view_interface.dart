import 'package:takvim_uygulamasi/models/Order.dart';
import 'package:takvim_uygulamasi/models/ProductQuantity.dart';

abstract class OrderViewInterface {
  Future<List<Order>> getOrder(String getToken);
  Future<List<Order>> getOrderReport(String getToken);
  Future setOrder(
      String token, String meetingRoomName, List<ProductQuantity> product);
  Future orderDelivered(String getToken, String id, bool isDelivered);
  List<Order> get getOrderList;
  List<Order> get getOrderReportList;
  bool get isDelivered;
}
