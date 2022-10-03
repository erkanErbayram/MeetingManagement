import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/user_api_interface.dart';
import 'package:takvim_uygulamasi/models/UsersModel.dart';
import 'package:takvim_uygulamasi/presentation/pages/calendars.dart';
import 'package:takvim_uygulamasi/screens/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserApiClient extends UserApiInterface {
  static const baseUrl = "http://192.168.56.1:8081/api/kullanici";
  String token;
  Users _user;

  String mesaj = "";
  SharedPreferences prefs;

/*   FlutterToast flutterToast; */

  Future loginUser(String email, String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data;
    if (email.contains('@')) {
      data = {"email": email, "password": password};
    } else {
      data = {"kullaniciAdi": email, "password": password};
    }

    final response = await http.post("$baseUrl/login", body: data);
    var jsonResponse;
    jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      prefs.setString("token", jsonResponse["token"]);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => CalendarsPage()),
          (Route<dynamic> route) => false);
      token = prefs.getString("token");
      return token;
    } else if (response.statusCode == 400) {
      return mesaj = jsonResponse["errors"];
    } else if (response.statusCode == 500) {
      return mesaj = jsonResponse["errors"];
    }
  }

  Future registerUser(String token, BuildContext context,
      {String nameSurname,
      String email,
      String userName,
      String password,
      String meetingRoomName,
      bool isEmployee,
      bool wifi,
      bool projector,
      bool whiteBoard,
      bool phone}) async {
    List meetingRoomFeatures = [];

    meetingRoomFeatures.add({
      "wifi": wifi,
      "projector": projector,
      "whiteBoard": whiteBoard,
      "phone": phone
    });
    var data;
    /*    flutterToast = FlutterToast(context); */
    if (email != null) {
      data = jsonEncode({
        "email": email,
        "nameSurname": nameSurname,
      });
    } else if (isEmployee) {
      data = jsonEncode({
        "userName": userName,
        "nameSurname": nameSurname,
        "password": password,
        "isEmployee": isEmployee,
      });
    } else if (email == null) {
      data = jsonEncode({
        "kullaniciAdi": userName,
        "password": password,
        "meetingRoomName": meetingRoomName,
        "meetingRoomFeatures": meetingRoomFeatures,
        "isEmployee": isEmployee,
      });
    }
    final response = await http.post("$baseUrl/register",
        body: data,
        headers: {"x-access-token": token, "content-type": "application/json"});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> currentUser(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (getToken != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<Users> getUserLogin(String getToken) async {
    try {
      final response =
          await http.get("$baseUrl/me", headers: {"x-access-token": getToken});

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        _user = Users.fromJson(jsonResponse);
      }
      return _user;
    } catch (err) {
      print(err);
    }
  }

  Future forgotPassword(String email, BuildContext context) async {
    Map data = {"email": email};
    final response = await http.post("$baseUrl/forgotPassword", body: data);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
      return true;
    } else {
      return false;
    }
  }

  Future changePassword(String password, String newPassword, String getToken,
      BuildContext context) async {
    Map data = {"password": password, "password1": newPassword};
    final response = await http.put("$baseUrl/changePassword",
        body: data, headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse["msg"]);
      logout(context);

      return true;
    } else {
      mesaj = "Şifreniz değiştirilememiştir.";
      /* _showToast(); */
      return false;
    }
  }

  Future<bool> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future getMeetingRoom(String getToken) async {
    try {
      final response =
          await http.get("$baseUrl/", headers: {"x-access-token": getToken});
      List<dynamic> jsonResponse;
      if (response.statusCode == 200) {
        jsonResponse = jsonDecode(response.body);
      }
      return jsonResponse.map((room) => Users.fromJson(room)).toList();
    } catch (err) {}
  }
}
