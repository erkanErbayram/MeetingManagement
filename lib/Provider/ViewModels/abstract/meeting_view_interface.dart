import 'package:takvim_uygulamasi/models/Meeting.dart';

abstract class MeetingViewInterface {
  Future<List<Meeting>> getMeeting(String getToken);
  Future<List<Meeting>> getMeetingReport(String getToken);
  Future<Meeting> getMeetingById(String getToken, String id);
  Future setMeeting(
      String token,
      String email,
      String companyName,
      String title,
      String subject,
      String meetingRoom,
      String startingDate,
      String endDate,
      List attendees);
  Future deleteMeeting(String getToken, String id);
  Future notMeeting(String getToken, String id, List<String> Notes);
  Future getMeetingPie();
  Future getHour();
  List<Meeting> get getMeetingList;
  List<Meeting> get getMeetingListReport;
  Meeting get getMeetingByID;
  List<Meeting> get getMeetingListPie;
  List get getMeetingListHour;
  bool get deleteMeet;
  bool get notMeet;
}
