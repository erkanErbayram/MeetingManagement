import 'package:flutter/widgets.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/meeting_room_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/meetingRoom_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/meeting_api_interface.dart';

import 'package:takvim_uygulamasi/locator.dart';
import 'package:takvim_uygulamasi/models/MeetingRoom.dart';

enum MeetingRoomState {
  //STATELERİ BURADA TANIMLIYORUZ.
  InitialMeetingRoomState, //kullanıcı ilk kez girdiğinde boş bir state
  MeetingRoomLoadingState, //kullanıcı arama yaptıgında loading state i
  MeetingRoomLoaded, //arama cevap döndürürse.
  MeetingRoomErrorState,
}

class MeetingRoomViewModel extends MeetingRoomViewInterface
    with ChangeNotifier {
  MeetingRoomApiInterface _meetingApi = locator<MeetingRoomApiInterface>();
  MeetingRoomState _state;

  List<MeetingRoom> _meetingRoom;
  List<MeetingRoom> get getMeetingRoomList => _meetingRoom;

  MeetingRoomState get state => _state;
  set state(MeetingRoomState value) {
    _state = value;
    notifyListeners();
  }

  MeetingRoomViewModel() {
    _meetingRoom = List<MeetingRoom>();
    _state = MeetingRoomState.InitialMeetingRoomState;
  }
  Future getMeetingRoom(String token) async {
    try {
      state = MeetingRoomState.MeetingRoomLoadingState;
      _meetingRoom = await _meetingApi.getRoom(token);
      state = MeetingRoomState.MeetingRoomLoaded;
      return _meetingRoom;
    } catch (e) {
      print(e);
      state = MeetingRoomState.MeetingRoomErrorState;
    }
  }
}
