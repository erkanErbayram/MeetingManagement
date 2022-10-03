import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/models/UsersModel.dart';

abstract class UserViewInterface {
  Users get getUser;
  List<Users> get getRoom;
  bool get getCurrent;
  bool get getKayit;
  String get getToken;
  Future<String> loginUser(String email, String password, BuildContext context);
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
      bool phone});
  Future<bool> currentUser(String getToken);
  Future<Users> getUserLogin(String getToken);
  Future forgotPassword(String email, BuildContext context);
  Future changePassword(String password, String newPassword, String getToken,
      BuildContext context);
  Future<bool> logout(BuildContext context);
  Future getMeetingRoom(String getToken);
}
