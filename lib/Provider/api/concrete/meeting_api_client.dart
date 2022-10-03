import 'dart:convert';
import 'package:device_calendar/device_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:takvim_uygulamasi/Provider/api/abstract/meeting_api_interface.dart';

import 'package:takvim_uygulamasi/models/Meeting.dart';

class MeetingApiClient extends MeetingApiInterface {
  List<Meeting> _meeting;
  List<Meeting> _meetingRapor;
  Meeting _meetingID;
  static const baseUrl = "http://192.168.56.1:8081/api/meeting";
  Future getMeeting(String getToken) async {
    final response =
        await http.get("$baseUrl", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _meeting =
          jsonResponse.map((meeting) => Meeting.fromJson(meeting)).toList();

      return _meeting;
    }
  }

  Future getMeetingReport(String getToken) async {
    final response = await http
        .get("$baseUrl/report", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _meetingRapor =
          jsonResponse.map((meeting) => Meeting.fromJson(meeting)).toList();

      return _meetingRapor;
    }
  }

  Future<Meeting> getMeetingById(String getToken, String id) async {
    final response =
        await http.get("$baseUrl/$id", headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      _meetingID = Meeting.fromJson(jsonResponse);

      return _meetingID;
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
      List<Attendee> attendees) async {
    List attend = [];
    attendees.map((ad) {
      attend.add({"email": ad.emailAddress, "nameSurname": ad.name});
    }).toList();

    var body = jsonEncode({
      "meetingRoom": meetingRoom,
      "companyName": companyName,
      "email": email,
      "title": title,
      "subject": subject,
      "startingDateTarihi": startingDate,
      "endDateTarihi": endDate,
      "attendees": attend,
    });

    final response = await http.post("$baseUrl/",
        body: body,
        headers: {"x-access-token": token, "content-type": "application/json"});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteMeeting(String getToken, String id) async {
    final response = await http.post("$baseUrl/delete",
        body: {"datetime": id}, headers: {"x-access-token": getToken});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future notMeeting(String getToken, String id, List<String> notes) async {
    List note = [];
    notes.map((n) {
      note.add({"note": n});
    }).toList();
    var body = jsonEncode({
      "Notes": notes,
    });
    print(body);

    final response = await http.put("$baseUrl/note/$id", body: body, headers: {
      "x-access-token": getToken,
      "content-type": "application/json"
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
