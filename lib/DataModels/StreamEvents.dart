// To parse this JSON data, do
//
//     final streamingEvents = streamingEventsFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

// StreamingEvents streamingEventsFromJson(String str) =>StreamingEvents.fromJson(json.decode(str));
//
// String streamingEventsToJson(StreamingEvents data) =>json.encode(data.toJson());

class StreamingEvents {
  StreamingEvents(
      {this.eventName,
      this.streamTime,
      this.over,
      this.imageUrl,
      this.eventRedirect,
      this.happening,
      this.redirectUrl,
      this.time,
      this.order});

  String eventName;
  String streamTime;
  String over;
  String imageUrl;
  String eventRedirect;
  String happening;
  String redirectUrl;
  Timestamp time;
  int order;

  factory StreamingEvents.fromJson(Map<String, dynamic> json) =>
      StreamingEvents(
          // time: json["time"],
          eventName: json["EventName"],
          streamTime: json["StreamTime"],
          over: json["Over"],
          imageUrl: json["ImageUrl"],
          eventRedirect: json["EventRedirect"],
          time: json["time"],
          happening: json["Happening"],
          order: json["order"],
          redirectUrl: json["RedirectUrl"]);

  Map<String, dynamic> toJson() => {
        "EventName": eventName,
        "StreamTime": streamTime,
        "Over": over,
        "ImageUrl": imageUrl,
        "EventRedirect": eventRedirect,
        "Happening": happening,
      };
}
