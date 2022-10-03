// To parse this JSON data, do
//
//     final meetingRoom = meetingRoomFromJson(jsonString);

import 'dart:convert';

List<MeetingRoom> meetingRoomFromJson(String str) => List<MeetingRoom>.from(
    json.decode(str).map((x) => MeetingRoom.fromJson(x)));

String meetingRoomToJson(List<MeetingRoom> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeetingRoom {
  MeetingRoom({
    this.wifi,
    this.projector,
    this.whiteboard,
    this.phone,
    this.id,
    this.companies,
    this.meetingRoomName,
  });

  bool wifi;
  bool projector;
  bool whiteboard;
  bool phone;
  String id;
  String companies;
  String meetingRoomName;

  factory MeetingRoom.fromJson(Map<String, dynamic> json) => MeetingRoom(
        wifi: json["wifi"],
        projector: json["projector"],
        whiteboard: json["whiteboard"],
        phone: json["phone"],
        id: json["_id"],
        companies: json["companies"],
        meetingRoomName: json["meetingRoomName"],
      );

  Map<String, dynamic> toJson() => {
        "wifi": wifi,
        "projector": projector,
        "whiteboard": whiteboard,
        "phone": phone,
        "_id": id,
        "companies": companies,
        "meetingRoomName": meetingRoomName,
      };
}
