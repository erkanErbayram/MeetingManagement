import 'package:takvim_uygulamasi/models/ProductQuantity.dart';

abstract class OrderApiInterface {
  Future getOrder(String getToken);
  Future getOrderReport(String getToken);
  Future setOrder(
      String token, String meetingRoomName, List<ProductQuantity> product);
  Future OrderDelivered(String getToken, String id, bool isDelivereD);
}
