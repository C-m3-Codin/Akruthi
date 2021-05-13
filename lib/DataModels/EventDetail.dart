// To parse this JSON data, do
//
//     final eventDetails = eventDetailsFromJson(jsonString);

import 'dart:convert';

// EventDetails eventDetailsFromJson(String str) => EventDetails.fromJson(json.decode(str));
//
// String eventDetailsToJson(EventDetails data) => json.encode(data.toJson());

class EventDetails {
  EventDetails({
    this.name,
    this.date,
    this.category,
    this.pointStructure,
    this.resultAnnounced,
    this.firstWinner,
    this.firstParticular,
    this.secondWinner,
    this.secondParticular,
    this.thirdWinner,
    this.thirdParticular,
    this.participants,
    this.rules,
  });

  String name;
  String date;
  String category;
  String pointStructure;
  String resultAnnounced;
  String firstWinner;
  String firstParticular;
  String secondWinner;
  String secondParticular;
  String thirdWinner;
  String thirdParticular;
  List<Participant> participants;
  List<Rule> rules;

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
        name: json["name"],
        date: json["date"],
        category: json["category"],
        pointStructure: json["pointStructure"],
        resultAnnounced: json["resultAnnounced"],
        firstWinner: json["FirstWinner"],
        firstParticular: json["FirstParticular"],
        secondWinner: json["SecondWinner"],
        secondParticular: json["SecondParticular"],
        thirdWinner: json["ThirdWinner"],
        thirdParticular: json["ThirdParticular"],
        participants: List<Participant>.from(
            json["participants"].map((x) => Participant.fromJson(x))),
        rules: List<Rule>.from(json["rules"].map((x) => Rule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "category": category,
        "pointStructure": pointStructure,
        "resultAnnounced": resultAnnounced,
        "FirstWinner": firstWinner,
        "FirstParticular": firstParticular,
        "SecondWinner": secondWinner,
        "SecondParticular": secondParticular,
        "ThirdWinner": thirdWinner,
        "ThirdParticular": thirdParticular,
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
