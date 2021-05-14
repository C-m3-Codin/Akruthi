// To parse this JSON data, do
//
//     final score = scoreFromJson(jsonString);

import 'dart:convert';

List<Score> scoreFromJson(String str) =>
    List<Score>.from(json.decode(str).map((x) => Score.fromJson(x)));

String scoreToJson(List<Score> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Score {
  Score({
    this.scoreClass,
    this.points,
  });

  String scoreClass;
  int points;

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        scoreClass: json["class"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "class": scoreClass,
        "points": points,
      };
}
