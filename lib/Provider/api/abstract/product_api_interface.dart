abstract class ProductApiInterface {
  Future getProduct(String getToken);
  Future setProduct(
      String token, String productName, int productPrice, int stock);
}
