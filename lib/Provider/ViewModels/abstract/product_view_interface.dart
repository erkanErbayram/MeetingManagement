import 'package:takvim_uygulamasi/models/Order.dart';

abstract class ProductViewInterface {
  List<Product> get getProductList;
  Future<List<Product>> getProduct(String getToken);
  Future setUrun(String token, String productName, int productPrice, int stock);
}
