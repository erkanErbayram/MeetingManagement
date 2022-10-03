import 'package:flutter/material.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/meeting_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/meeting_api_interface.dart';

import 'package:takvim_uygulamasi/locator.dart';
import 'package:takvim_uygulamasi/models/Meeting.dart';

enum MeetingState {
  InitialMeetingState,
  MeetingLoadingState,
  MeetingLoaded,
  MeetingErrorState,
}

class MeetingViewModel extends MeetingViewInterface with ChangeNotifier {
  MeetingApiInterface _meetingApi = locator<MeetingApiInterface>();
  UserViewModel _userViewModel;
  List<Meeting> _list = [];
  int i = 0;
  List _listHour = [0, 0, 0, 0, 0, 0, 0];
  int totalHour = 0;
  int basSaat = 0;
  int bitSaat = 0;
  MeetingState _state;
  List<Meeting> _meeting;
  List<Meeting> _meetingReport;
  Meeting _meetingByID;
  bool meet;
  bool _delete;
  bool _not;
  List<Meeting> get getMeetingList => _meeting;
  List<Meeting> get getMeetingListPie => _list;
  List<Meeting> get getMeetingListReport => _meetingReport;
  Meeting get getMeetingByID => _meetingByID;
  List get getMeetingListHour => _listHour;
  MeetingState get state => _state;
  bool get deleteMeet => _delete;
  bool get notMeet => _not;
  set state(MeetingState value) {
    _state = value;
    notifyListeners();
  }

  MeetingViewModel() {
    _meeting = List<Meeting>();
    _meetingReport = List<Meeting>();
    _meetingByID = Meeting();
  }

  Future<List<Meeting>> getMeeting(String getToken) async {
    try {
      state = MeetingState.MeetingLoadingState;
      _meeting = await _meetingApi.getMeeting(getToken);
      state = MeetingState.MeetingLoaded;
      return _meeting;
    } catch (e) {
      print(e);
      state = MeetingState.MeetingErrorState;
    }
  }

  Future<List<Meeting>> getMeetingReport(String getToken) async {
    try {
      state = MeetingState.MeetingLoadingState;
      _meetingReport = await _meetingApi.getMeetingReport(getToken);
      state = MeetingState.MeetingLoaded;
      return _meetingReport;
    } catch (e) {
      print(e);
      state = MeetingState.MeetingErrorState;
    }
  }

  Future<Meeting> getMeetingById(String getToken, String id) async {
    try {
      state = MeetingState.MeetingLoadingState;
      _meetingByID = await _meetingApi.getMeetingById(getToken, id);
      state = MeetingState.MeetingLoaded;
      return _meetingByID;
    } catch (e) {
      print(e);
      state = MeetingState.MeetingErrorState;
    }
  }

  Future setMeeting(
      String token,
      String email,
      String companyName,
      String title,
      String subject,
      String meetingRoom,
      String startingDate,
      String endDate,
      List attendees) async {
    try {
      meet = await _meetingApi.setMeeting(token, email, companyName, title,
          subject, meetingRoom, startingDate, endDate, attendees);
    } catch (err) {
      print(err);
    }
  }

  Future deleteMeeting(String getToken, String id) async {
    try {
      _delete = await _meetingApi.deleteMeeting(getToken, id);
    } catch (err) {
      print(err);
    }
  }

  Future notMeeting(String getToken, String id, List<String> notes) async {
    try {
      _not = await _meetingApi.notMeeting(getToken, id, notes);
    } catch (err) {
      print(err);
    }
  }

  Future getMeetingPie() async {
    if (_userViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    }

    await getMeetingReport(_userViewModel.getToken);

    getMeetingListReport.map((meeting) {
      if (meeting.email == _userViewModel.getUser.email) {
        _list.add(meeting);
      }
    }).toList();
  }

  getHour() async {
    if (_userViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    }

    await getMeetingReport(_userViewModel.getToken);

    getMeetingListReport.map((meeting) {
      if (meeting.email == _userViewModel.getUser.email) {
        totalHour = meeting.endDate.hour - meeting.startingDate.hour;
        _list[getMeetingListReport[i].startingDate.weekday - 1] += totalHour;
      }
      i++;
    }).toList();
  }
}
