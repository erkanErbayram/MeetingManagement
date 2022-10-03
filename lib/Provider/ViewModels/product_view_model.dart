import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/product_view_interface.dart';

import 'package:takvim_uygulamasi/locator.dart';
import 'package:takvim_uygulamasi/models/Product.dart';

enum ProductState {
  InitialProductState,
  ProductLoadingState,
  ProductLoaded,
  ProductErrorState,
}

class ProductViewModel extends ProductViewInterface with ChangeNotifier {
  ProductApiInterface _productApi = locator<ProductApiInterface>();
  ProductState _state;
  List<Product> _product;
  bool result;

  List<Product> get getProductList => _product;
  ProductState get state => _state;

  set state(ProductState value) {
    _state = value;
    notifyListeners();
  }

  ProductViewModel() {
    _product = List<Product>();
  }

  Future<List<Product>> getProduct(String getToken) async {
    try {
      state = ProductState.ProductLoadingState;
      _product = await _productApi.getProduct(getToken);
      state = ProductState.ProductLoaded;
      return _product;
    } catch (e) {
      print(e);
      state = ProductState.ProductErrorState;
    }
  }

  Future setProduct(
      String token, String productName, int productPrice, int stock) async {
    try {
      result =
          await _productApi.setProduct(token, productName, productPrice, stock);
    } catch (err) {
      print(err);
    }
  }
}
