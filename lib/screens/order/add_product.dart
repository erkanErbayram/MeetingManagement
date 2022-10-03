import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/product_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  ProductViewModel _productViewModel;
  UserViewModel _userViewModel;
  FToast flutterToast;
  String urunAdi = "";
  int stok = 0;
  int urunFiyati = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Urun Adı', hintText: ''),
              onSaved: (String value) {
                urunAdi = value;
              },
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Urun Fiyatı', hintText: ''),
              onSaved: (String value) {
                urunFiyati = int.parse(value);
              },
              autofocus: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Stok', hintText: ''),
              onSaved: (String value) {
                stok = int.parse(value);
              },
              autofocus: false,
            ),
          ),
          InkWell(
            onTap: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                await _productViewModel.setProduct(
                    _userViewModel.getToken, urunAdi, urunFiyati, stok);
                if (_productViewModel.sonuc) {
                  Fluttertoast.showToast(
                      msg: "Urun Eklendi",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  _formKey.currentState.reset();
                }
              }
            },
            child: Container(
              width: width * 0.3,
              height: height * 0.05,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19.0),
                color: Colors.blue,
                border: Border.all(width: 2.0, color: const Color(0xffffffff)),
              ),
              child: Center(
                child: Text(
                  'Kaydet',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 16,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
