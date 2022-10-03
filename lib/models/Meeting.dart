import 'dart:convert';

List<Meeting> meetingFromJson(String str) =>
    List<Meeting>.from(json.decode(str).map((x) => Meeting.fromJson(x)));

String meetingToJson(List<Meeting> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meeting {
  Meeting({
    this.Notes,
    this.id,
    this.meetingRoom,
    this.companyName,
    this.firmalar,
    this.kullanici,
    this.email,
    this.title,
    this.subject,
    this.startingDate,
    this.endDate,
    this.attendees,
    this.date,
    this.v,
  });

  List<String> Notes;
  String id;
  String meetingRoom;
  String companyName;
  String firmalar;
  String kullanici;
  String email;
  String title;
  String subject;
  DateTime startingDate;
  DateTime endDate;
  List<Attendees> attendees;
  DateTime date;
  int v;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        Notes: json["Notes"] == null
            ? null
            : List<String>.from(json["Notes"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        meetingRoom: json["meetingRoom"] == null ? null : json["meetingRoom"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        firmalar: json["firmalar"] == null ? null : json["firmalar"],
        kullanici: json["kullanici"] == null ? null : json["kullanici"],
        email: json["email"] == null ? null : json["email"],
        title: json["title"] == null ? null : json["title"],
        subject: json["subject"] == null ? null : json["subject"],
        startingDate: json["startingDate"] == null
            ? null
            : DateTime.parse(json["startingDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        attendees: json["attendees"] == null
            ? null
            : List<Attendee>.from(
                json["attendees"].map((x) => attendees.fromJson(x))),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "notes": notes == null ? null : List<dynamic>.from(Notes.map((x) => x)),
        "_id": id == null ? null : id,
        "meetingRoom": meetingRoom == null ? null : meetingRoom,
        "companyName": companyName == null ? null : companyName,
        "firmalar": firmalar == null ? null : firmalar,
        "kullanici": kullanici == null ? null : kullanici,
        "email": email == null ? null : email,
        "title": title == null ? null : title,
        "subject": subject == null ? null : subject,
        "startingDate":
            startingDate == null ? null : startingDate.toIso8601String(),
        "endDate": endDate == null ? null : endDate.toIso8601String(),
        "attendees": attendees == null
            ? null
            : List<dynamic>.from(attendees.map((x) => x.toJson())),
        "date": date == null ? null : date.toIso8601String(),
        "__v": v == null ? null : v,
      };
}

class Attendees {
  Attendees({
    this.id,
    this.email,
    this.adSoyad,
  });

  String id;
  String email;
  String adSoyad;

  factory Attendees.fromJson(Map<String, dynamic> json) => Attendees(
        id: json["_id"] == null ? null : json["_id"],
        email: json["email"] == null ? null : json["email"],
        adSoyad: json["adSoyad"] == null ? null : json["adSoyad"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "email": email == null ? null : email,
        "adSoyad": adSoyad == null ? null : adSoyad,
      };
}
