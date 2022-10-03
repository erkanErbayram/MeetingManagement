import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/user_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/user_api_interface.dart';

import 'package:takvim_uygulamasi/locator.dart';
import 'package:takvim_uygulamasi/models/UsersModel.dart';

enum UserState {
  InitialUserState,
  UserLoadingState,
  UserLoadedState,
  UserErrorState,
  UserNotState
}

class UserViewModel extends UserViewInterface with ChangeNotifier {
  UserApiInterface userApi = locator<UserApiInterface>();
  UserState _state;
  Users _users;
  List<Users> _meetingRoom;
  String _token;
  bool _current;
  bool _password;
  bool changed;
  bool _kayit;
  Users get getUser => _users;
  List<Users> get getRoom => _meetingRoom;
  bool get getCurrent => _current;
  bool get getKayit => _kayit;
  String get getToken => _token;
  UserState get state => _state;
  UserViewModel() {
    _users = Users();
    _state = UserState.InitialUserState;
  }
  set state(UserState value) {
    _state = value;
    notifyListeners();
  }

  set setUser(Users value) {
    _users = value;
    notifyListeners();
  }

  set setToken(String value) {
    _token = value;
    notifyListeners();
  }

  set setKayit(bool value) {
    _kayit = value;
    notifyListeners();
  }

  Future<String> loginUser(
      String email, String password, BuildContext context) async {
    try {
      state = UserState.UserLoadingState;
      // _users = await userApi.loginUser(email, password, context);
      _token = await userApi.loginUser(email, password, context);
      print(_token);
      return _token;
    } catch (err) {
      state = UserState.UserErrorState;
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
    try {
      _kayit = await userApi.registerUser(token, context,
          nameSurname: nameSurname,
          email: email,
          userName: userName,
          password: password,
          meetingRoomName: meetingRoomName,
          isEmployee: isEmployee,
          wifi: wifi,
          projector: projector,
          whiteBoard: whiteBoard,
          phone: phone);
      return _kayit;
    } catch (err) {
      print(err);
    }
  }

  Future forgotPassword(String email, BuildContext context) async {
    try {
      _password = await userApi.forgotPassword(email, context);
    } catch (err) {
      print(err);
    }
  }

  Future changePassword(String password, String newPassword, String getToken,
      BuildContext context) async {
    try {
      changed = await userApi.changePassword(
          password, newPassword, getToken, context);
    } catch (err) {
      print(err);
    }
  }

  Future logout(BuildContext context) async {
    try {
      return await userApi.logout(context);
    } catch (err) {
      print(err);
    }
  }

  Future currentUser(String getToken) async {
    try {
      _token = getToken;
      _current = await userApi.currentUser(getToken);
      notifyListeners();
      return _current;
    } catch (err) {}
  }

  Future getUserLogin(String getToken) async {
    try {
      setUser = await userApi.getUserLogin(getToken);
    } catch (e) {
      print(e);
    }
  }

  Future getMeetingRoom(String getToken) async {
    try {
      _meetingRoom = await userApi.getMeetingRoom(getToken);
    } catch (e) {
      print(e);
    }
  }
}
