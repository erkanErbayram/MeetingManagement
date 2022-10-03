import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  Users({
    this.isAdmin,
    this.isMeetingRoom,
    this.id,
    this.userName,
    this.nameSurname,
    this.email,
    this.meetingRoomName,
    this.companies,
    this.meetingRoomFeatures,
    this.isEmployee,
    this.v,
  });

  bool isAdmin;
  bool isMeetingRoom;
  bool isEmployee;
  String id;
  String userName;
  String nameSurname;
  String email;
  String meetingRoomName;
  String companies;
  List<MeetingRoomFeatures> meetingRoomFeatures;
  int v;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        isAdmin: json["isAdmin"] == null ? null : json["isAdmin"],
        isEmployee: json["isEmployee"] == null ? null : json["isEmployee"],
        isMeetingRoom:
            json["isMeetingRoom"] == null ? null : json["isMeetingRoom"],
        id: json["_id"] == null ? null : json["_id"],
        userName: json["userName"] == null ? null : json["userName"],
        nameSurname: json["nameSurname"] == null ? null : json["nameSurname"],
        email: json["email"] == null ? null : json["email"],
        meetingRoomName:
            json["meetingRoomName"] == null ? null : json["meetingRoomName"],
        companies: json["companies"] == null ? null : json["companies"],
        meetingRoomFeatures: json["meetingRoomFeatures"] == null
            ? null
            : List<MeetingRoomFeatures>.from(json["meetingRoomFeatures"]
                .map((x) => MeetingRoomFeatures.fromJson(x))),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "isAdmin": isAdmin == null ? null : isAdmin,
        "isEmployee": isEmployee == null ? null : isEmployee,
        "isMeetingRoom": isMeetingRoom == null ? null : isMeetingRoom,
        "_id": id == null ? null : id,
        "userName": userName == null ? null : userName,
        "nameSurname": nameSurname == null ? null : nameSurname,
        "email": email == null ? null : email,
        "meetingRoomName": meetingRoomName == null ? null : meetingRoomName,
        "companies": companies == null ? null : companies,
        "meetingRoomFeatures": meetingRoomFeatures == null
            ? null
            : List<dynamic>.from(meetingRoomFeatures.map((x) => x.toJson())),
        "__v": v == null ? null : v,
      };
}

class MeetingRoomFeatures {
  MeetingRoomFeatures({
    this.wifi,
    this.projector,
    this.whiteboard,
    this.phone,
    this.id,
  });

  bool wifi;
  bool projector;
  bool whiteboard;
  bool phone;
  String id;

  factory MeetingRoomFeatures.fromJson(Map<String, dynamic> json) =>
      MeetingRoomFeatures(
        wifi: json["wifi"] == null ? null : json["wifi"],
        projector: json["projector"] == null ? null : json["projector"],
        whiteboard: json["whiteboard"] == null ? null : json["whiteboard"],
        phone: json["phone"] == null ? null : json["phone"],
        id: json["_id"] == null ? null : json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "wifi": wifi == null ? null : wifi,
        "projector": projector == null ? null : projector,
        "whiteboard": whiteboard == null ? null : whiteboard,
        "phone": phone == null ? null : phone,
        "_id": id == null ? null : id,
      };
}
