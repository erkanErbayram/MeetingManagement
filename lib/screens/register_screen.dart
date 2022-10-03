import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

class RegisterScreen extends StatefulWidget {
  UserViewModel _userViewModel;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _autovalidate;
  UserViewModel _userViewModel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String passwordEmployee = "";
  String nameSurname = "";
  String meetingName = "";
  String userName = "";
  String meetingRoomName = "";
  String mesaj = "";
  String employeenameSurname = "";
  String employeeuserName = "";
  bool isEmployee = false;
  bool wifi = false;
  bool projector = false;
  bool whiteBoard = false;
  bool phone = false;
  bool features = false;
  String dropdownValue = 'Kullanıcı Kaydı';

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _userViewModel.getUser.adminMi
                ? adminMi()
                : Center(
                    child: Text("data"),
                  )
          ],
        ),
      ),
    );
  }

  Widget adminMi() {
    _autovalidate = false;
    return Form(
      autovalidate: _autovalidate,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
                top: 30.0, left: 20, right: 20, bottom: 10),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                /*  style: TextStyle(color: Colors.deepPurple), */
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    _formKey.currentState.reset();
                  });
                },
                items: <String>[
                  'Kullanıcı Kaydı',
                  'Toplantı Odası Kaydı',
                  "employee Kaydı"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          dropdownValue == "Kullanıcı Kaydı"
              ? kullaniciKaydi(context)
              : dropdownValue == "Toplantı Odası Kaydı"
                  ? toplantiOdasiKaydi(context)
                  : employeeKaydi(context),
        ],
      ),
    );
  }

  Widget kullaniciKaydi(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration:
                const InputDecoration(labelText: 'Ad Soyad', hintText: ''),
            onSaved: (String value) {
              nameSurname = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Email', hintText: ''),
            onSaved: (String value) {
              email = value;
            },
          ),
        ),
        RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              await _userViewModel.registerUser(
                  _userViewModel.getToken, context,
                  nameSurname: nameSurname, email: email);
              if (_userViewModel.getKayit) {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturuldu",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturulamadı",
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
    );
  }

  Widget toplantiOdasiKaydi(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
            validator: (String value) {
              value.length < 0 ? "Kullanıcı Adı boş geçilemez." : null;
            },
            onSaved: (String value) {
              userName = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Toplantı Salonu Adı'),
            validator: (String value) {
              value.length < 0 ? "Toplantı Salon Adı boş geçilemez." : null;
            },
            onSaved: (String value) {
              meetingRoomName = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            validator: (String value) {
              value.length < 2 ? "En az 6 karakter giriniz." : null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Şifre'),
            onSaved: (String value) {
              password = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: SwitchListTile(
            value: features,
            onChanged: (value) => setState(() => features = value),
            title: Text('Toplantı Salonu Özellikleri'),
          ),
        ),
        features
            ? Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SwitchListTile(
                      value: wifi,
                      onChanged: (value) => setState(() => wifi = value),
                      title: Text('Wifi'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SwitchListTile(
                      value: projector /* "_event.allDay" */,
                      onChanged: (value) => setState(() => projector = value),
                      title: Text('Projektör'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SwitchListTile(
                      value: whiteBoard,
                      onChanged: (value) => setState(() => whiteBoard = value),
                      title: Text('Beyaz Tahta'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SwitchListTile(
                      value: phone /* "_event.allDay" */,
                      onChanged: (value) => setState(() => phone = value),
                      title: Text('phone'),
                    ),
                  ),
                ],
              )
            : Center(),
        RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              var user = await _userViewModel.registerUser(
                  _userViewModel.getToken, context,
                  userName: userName,
                  password: password,
                  meetingRoomName: meetingRoomName,
                  wifi: wifi,
                  projector: projector,
                  whiteBoard: whiteBoard,
                  phone: phone,
                  isEmployee: false);
              if (_userViewModel.getKayit) {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturuldu",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturulamadı",
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
    );
  }

  Widget employeeKaydi(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration:
                const InputDecoration(labelText: 'Ad Soyad', hintText: ''),
            onSaved: (String value) {
              employeenameSurname = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            decoration:
                const InputDecoration(labelText: 'Kullanıcı Adı', hintText: ''),
            onSaved: (String value) {
              employeeuserName = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextFormField(
            validator: (String value) {
              value.length < 2 ? "En az 6 karakter giriniz." : null;
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Şifre'),
            onSaved: (String value) {
              passwordEmployee = value;
            },
          ),
        ),
        /*  CheckboxListTile(
          title: Text("employee Mi"),
          value: isEmployee,
          onChanged: (newValue) {
            setState(() {
              isEmployee = newValue;
            });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ), */
        RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              var res = await _userViewModel.registerUser(
                  _userViewModel.getToken, context,
                  nameSurname: employeenameSurname,
                  userName: employeeuserName,
                  password: passwordEmployee,
                  isEmployee: true);
              if (_userViewModel.getKayit) {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturuldu",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Kayıt Oluşturulamadı",
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
    );
  }
}
