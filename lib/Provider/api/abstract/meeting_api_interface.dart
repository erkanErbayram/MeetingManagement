import 'package:takvim_uygulamasi/models/Meeting.dart';

abstract class MeetingApiInterface {
  Future getMeeting(String getToken);
  Future getMeetingReport(String getToken);
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
      List<Attendee> attendees);
  Future deleteMeeting(String getToken, String id);
  Future notMeeting(String getToken, String id, List<String> Notes);
}
