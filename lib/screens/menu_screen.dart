import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/screens/change_password.dart';
import 'package:takvim_uygulamasi/screens/rapor/raporlar.dart';
import 'package:takvim_uygulamasi/screens/register_screen.dart';
import 'package:takvim_uygulamasi/screens/siparis/siparis_ekle.dart';
import 'package:takvim_uygulamasi/screens/siparis/siparis_listesi.dart';

import 'Notes/Notes.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  UserViewModel _userViewModel;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: _userViewModel.getUser.adminMi ? admin() : kullanici(),
    );
  }

  Widget admin() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Kullanıcı / Personel Kaydı / Toplantı Salonu Kaydı"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RegisterScreen();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Şifre Değiştir"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangePassword();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Raporlar"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Raporlar();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Notes"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Notes();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Siparis Ver"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddOrder();
            }));
          },
        ),
        /*  InkWell(
          onTap: () async {
            _userViewModel.logout(context);
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
        ) */
        Container(
          padding: EdgeInsets.only(right: 120, left: 120),
          child: RaisedButton(
            onPressed: () {
              _userViewModel.logout(context);
            },
            child: Text(
              "Çıkış Yap",
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget kullanici() {
    return ListView(
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Şifre Değiştir"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangePassword();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Raporlar"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Raporlar();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Notes"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Notes();
            }));
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Siparis Ver"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddOrder();
            }));
          },
        ),
        Container(
          padding: EdgeInsets.only(right: 120, left: 120),
          child: RaisedButton(
            onPressed: () {
              _userViewModel.logout(context);
            },
            child: Text(
              "Çıkış Yap",
              style: TextStyle(
                letterSpacing: 1.5,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
