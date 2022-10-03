import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/screens/meeting_list.dart';
import 'package:takvim_uygulamasi/screens/menu_screen.dart';
import 'package:takvim_uygulamasi/screens/siparis/siparis_anaSayfa.dart';
import 'package:takvim_uygulamasi/screens/siparis/siparis_listesi.dart';

import 'calendar_events.dart';

class CalendarsPage extends StatefulWidget {
  CalendarsPage({Key key}) : super(key: key);

  @override
  _CalendarsPageState createState() {
    return _CalendarsPageState();
  }
}

class _CalendarsPageState extends State<CalendarsPage> {
  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  int index2 = 0;
  UserViewModel _userViewModel;

  String mesaj = "";
/*   List<Calendar> get _writableCalendars =>
      _calendars?.where((c) => !c.isReadOnly)?.toList() ?? <Calendar>[]; */

  /*  List<Calendar> get _readOnlyCalendars =>
      _calendars?.where((c) => c.isReadOnly)?.toList() ?? <Calendar>[]; */

  _CalendarsPageState() {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Toplantı Uygulaması',
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MenuScreen();
                  }));
                })
          ],
        ),
        body: mesaj.isEmpty ? Text("") : Center(child: Text(mesaj)));
  }

  Future _retrieveCalendars() async {
    _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }
      await _userViewModel.getUserLogin(_userViewModel.getToken);
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

      setState(() {
        _calendars = calendarsResult?.data;
      });
      int index1 = 0;
      // ignore: await_only_futures
      await _calendars.map((ad) {
        if (ad.name == _userViewModel.getUser.email) {
          setState(() {
            index2 = index1;
          });
        }
        ++index1;
      }).toList();

      if (!_calendars.isEmpty) {
        if (_calendars[index2].name == _userViewModel.getUser.email &&
            !_userViewModel.getUser.toplantiOdasiMi) {
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => CalendarEventsPage(
                  _calendars[index2],
                  key: Key('calendarEventsPage'),
                ),
              ),
              (Route<dynamic> route) => false);
        } else if (_userViewModel.getUser.toplantiOdasiMi &&
            !_userViewModel.getUser.personelMi) {
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MeetingList()),
              (Route<dynamic> route) => false);
        } else if (_userViewModel.getUser.personelMi) {
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeOrder()),
              (Route<dynamic> route) => false);
        } else {
          mesaj = "Lütfen mailinizi takvim uygulaması ile senkronize ediniz.";
        }
      } else if (_userViewModel.getUser.toplantiOdasiMi &&
          !_userViewModel.getUser.personelMi) {
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MeetingList()),
            (Route<dynamic> route) => false);
      } else if (_userViewModel.getUser.personelMi) {
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeOrder()),
            (Route<dynamic> route) => false);
      } else {
        mesaj = "Lütfen mailinizi takvim uygulaması ile senkronize ediniz.";
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
