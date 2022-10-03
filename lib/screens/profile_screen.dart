import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/screens/change_password.dart';
import 'package:takvim_uygulamasi/screens/register_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserViewModel _userViewModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: _userViewModel.getUser.adminMi ? admin() : kullanici(),
    );
  }

  Widget admin() {
    return ListView(
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.arrow_forward),
          title: Text("Kullanıcı Kaydı / Toplantı Salonu Kaydı"),
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
