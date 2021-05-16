// To parse this JSON data, do
//
//     final eventDetails = eventDetailsFromJson(jsonString);

import 'dart:convert';

EventDetails eventDetailsFromJson(String str) =>
    EventDetails.fromJson(json.decode(str));

String eventDetailsToJson(EventDetails data) => json.encode(data.toJson());

class EventDetails {
  EventDetails({
    this.name,
    this.date,
    this.category,
    this.status,
    this.description,
    this.resultsAnnounced,
    this.winnerFirst,
    this.firstParticulars,
    this.winnerSecond,
    this.secondParticulars,
    this.winnerThird,
    this.thirdParticulars,
    this.posterUrl,
    this.coordinator1,
    this.c1Number,
    this.coordinator2,
    this.c2Number,
    this.participants,
    this.rules,
  });

  String name;
  String date;
  String category;
  String status;
  String description;
  String resultsAnnounced;
  String winnerFirst;
  String firstParticulars;
  String winnerSecond;
  String secondParticulars;
  String winnerThird;
  String thirdParticulars;
  String posterUrl;
  String coordinator1;
  String c1Number;
  String coordinator2;
  String c2Number;
  List<Participant> participants;
  List<Rule> rules;

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
        name: json["name"],
        date: json["date"],
        category: json["category"],
        status: json["status"],
        description: json["description"],
        resultsAnnounced: json["resultsAnnounced"],
        winnerFirst: json["winnerFirst"],
        firstParticulars: json["firstParticulars"],
        winnerSecond: json["winnerSecond"],
        secondParticulars: json["secondParticulars"],
        winnerThird: json["winnerThird"],
        thirdParticulars: json["thirdParticulars"],
        posterUrl: json["posterUrl"],
        coordinator1: json["coordinator1"],
        c1Number: json["c1number"].toString(),
        coordinator2: json["coordinator2"],
        c2Number: json["c2number"].toString(),
        participants: List<Participant>.from(
            json["participants"].map((x) => Participant.fromJson(x))),
        rules: List<Rule>.from(json["rules"].map((x) => Rule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "category": category,
        "status": status,
        "description": description,
        "resultsAnnounced": resultsAnnounced,
        "winnerFirst": winnerFirst,
        "firstParticulars": firstParticulars,
        "winnerSecond": winnerSecond,
        "secondParticulars": secondParticulars,
        "winnerThird": winnerThird,
        "thirdParticulars": thirdParticulars,
        "posterUrl": posterUrl,
        "coordinator1": coordinator1,
        "c1number": c1Number,
        "coordinator2": coordinator2,
        "c2number": c2Number,
        "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
        "rules": List<dynamic>.from(rules.map((x) => x.toJson())),
      };
}

class Participant {
  Participant({
    this.name,
    this.particulars,
  });

  String name;
  String particulars;

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        name: json["name"],
        particulars: json["particulars"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "particulars": particulars,
      };
}

class Rule {
  Rule({
    this.desc,
  });

  String desc;

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
      };
}
