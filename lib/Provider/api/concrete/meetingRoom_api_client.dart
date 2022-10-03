import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:takvim_uygulamasi/Provider/api/abstract/meetingRoom_api_interface.dart';
import 'package:takvim_uygulamasi/models/MeetingRoom.dart';

class MeetingRoomApiClient extends MeetingRoomApiInterface {
  List<MeetingRoom> _room;
  static const baseUrl = "http://192.168.56.1:8081/api/meetingRoom";

  Future getRoom(String token) async {
    final response =
        await http.get("$baseUrl/", headers: {"x-access-token": token});

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      _room = jsonResponse.map((room) => MeetingRoom.fromJson(room)).toList();

      return _room;
    }
  }
}
