import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  UserViewModel _userViewModel;
  FToast flutterToast;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String eskiPassword = "";
  String yeniPassword = "";
  String yeniPassword2 = "";

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Şifre Değiştir"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Şifre Değiştir",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Şifreniz', hintText: ''),
                        onSaved: (String value) {
                          eskiPassword = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Yeni Şifre', hintText: ''),
                        onSaved: (String value) {
                          yeniPassword = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Yeni Şifre Tekrar', hintText: ''),
                        onSaved: (String value) {
                          yeniPassword2 = value;
                        },
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (yeniPassword != yeniPassword2) {
                            
                              Fluttertoast.showToast(
                                msg: "Parolanız Eşleşmedi.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            _userViewModel.sifreDegistir(eskiPassword,
                                yeniPassword, _userViewModel.getToken, context);
                            Fluttertoast.showToast(
                                msg: "Şifreniz Değiştirildi",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      },
                      child: Text(
                        "Kaydet",
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
