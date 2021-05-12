// To parse this JSON data, do
//
//     final regEvent = regEventFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RegEvent regEventFromJson(String str) => RegEvent.fromJson(json.decode(str));

String regEventToJson(RegEvent data) => json.encode(data.toJson());

class RegEvent {
  RegEvent({
    this.eventName,
    this.imageUrl,
    this.sheet,
    this.time,
  });

  String eventName;
  String imageUrl;
  String sheet;
  Timestamp time;

  factory RegEvent.fromJson(Map<String, dynamic> json) => RegEvent(
        eventName: json["EventName"],
        imageUrl: json["ImageUrl"],
        sheet: json["Sheet"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "EventName": eventName,
        "ImageUrl": imageUrl,
        "Sheet": sheet,
        "time": time,
      };
}
