// To parse this JSON data, do
//
//     final streamingEvents = streamingEventsFromJson(jsonString);

import 'dart:convert';

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
      this.redirectUrl});

  String eventName;
  String streamTime;
  String over;
  String imageUrl;
  String eventRedirect;
  String happening;
  String redirectUrl;

  factory StreamingEvents.fromJson(Map<String, dynamic> json) =>
      StreamingEvents(
          eventName: json["EventName"],
          streamTime: json["StreamTime"],
          over: json["Over"],
          imageUrl: json["ImageUrl"],
          eventRedirect: json["EventRedirect"],
          happening: json["Happening"],
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
