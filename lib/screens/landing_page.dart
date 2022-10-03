import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/presentation/pages/calendars.dart';
import 'package:takvim_uygulamasi/screens/login_screen.dart';
import 'package:takvim_uygulamasi/screens/meeting_list.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  UserViewModel _userViewModel;
  @override
  void initState() {
    super.initState();
    deneme();
  }

  deneme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userViewModel.currentUser(prefs.getString("token"));
    });
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.getCurrent == null) {
      return Scaffold(
        body: CircularProgressIndicator(),
      );
    } else if (_userViewModel.getCurrent == false) {
      return LoginScreen();
    } else {
      return CalendarsPage() /* ForgotScreen()*/;
    }
  }
}
