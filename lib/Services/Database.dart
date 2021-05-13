import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // <List<MatchIpl>>
  geDateofMatche() {
    return db
        .collection("StreamEvents")
        .orderBy("time", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((documents) => StreamingEvents.fromJson(documents.data()))
            .toList());
  }

  geStreamEvents() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<StreamingEvents> data = [];
    db
        .collection("StreamEvents")
        .orderBy("time", descending: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        // data.add(StreamingEvents.fromJson(json.decode(result.data())));
        data.add(
            StreamingEvents.fromJson(json.decode(result.data().toString())));
      });
    });
    return data;
  }
}

Future<List<StreamingEvents>> streamingEvents() async {
  List<StreamingEvents> streamEventList = [];
  // print(postPath);
  print("\n\n");
  String happening = "No";
  await FirebaseFirestore.instance
      .collection("StreamEvents")
      .orderBy("time", descending: false)
      .get()
      .then((querysnapshot) {
    querysnapshot.docs.forEach((element) {
      // print(element.data()['title']);
      if (happening == "No") {
        print(
            "\n\n\n\nchecking ${element.data()["Happening"]}      ${element.data()["EventName"]}\n\n\n\n");
        if (element.data()["Happening"] == "Yes") {
          happening = "Yes";
          print(
              "\n\n\n\n\nadded to event ${element.data()["EventName"]}\n\n\n\n");
          streamEventList.add(
              // StreamingEvents.fromJson(json.decode(json.encode(element.data()))));
              StreamingEvents.fromJson(element.data()));
        }
      } else {
        print(
            "\n\n\n\n\nadded to event ${element.data()["EventName"]}\n\n\n\n");
        streamEventList.add(
            // StreamingEvents.fromJson(json.decode(json.encode(element.data()))));
            StreamingEvents.fromJson(element.data()));
      }
    });
  });

  // print('retrieved: ${postFromFirebase.eventName}');
  return streamEventList;
}

Future<List<RegEvent>> generalEventList() async {
  List<RegEvent> regularEvent = [];
  // print(postPath);
  print("\n\n");
  await FirebaseFirestore.instance
      .collection("generalEvents")
      .get()
      .then((querysnapshot) {
    querysnapshot.docs.forEach((element) {
      print("\n\n\n\n\n${element.data().toString()}\n\n\n\n\n\n");
      // print(element.data()['title']);
      regularEvent.add(RegEvent.fromJson(element.data()));
    });
  });

  // print('retrieved: ${postFromFirebase.eventName}');
  print("\n\n\n\n\n\nHere\n$regularEvent\n\n\n\n\n\n\n\n\n");
  return regularEvent;
}

Future<EventDetails> fetchAlbum(String sheetLink) async {
  // final response = await http.get(Uri.https(sheetLink,
  //     '/macros/s/AKfycbwR3Iv5tCnJYFOZPBsGZFLZdyJdXjFrAxGH2iF-o4AiNwFHsMg71C7UPgCfz2F_WyKDXQ/exec?sheetID=1IiNLptM1TgGBgk1EkHbbsMCZveyFBRDk1IGMSlNNjxo&eventName=event1'));

  var url = Uri.parse(sheetLink);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print(
        "\n\n\n\n\n\n\n\n\n\n from 82\n\n ${response.body}\n\n\\n\n\n\n\n\n\n\n\\n\n\n");
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return EventDetails.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
