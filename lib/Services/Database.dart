import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class DatabaseServices {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // <List<MatchIpl>>
  geDateofMatche() {
    return db
        .collection("StreamEvents")
        .orderBy("Time", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((documents) => StreamingEvents.fromJson(documents.data()))
            .toList());
  }

  geStreamEvents() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<StreamingEvents> data = [];
    db.collection("StreamEvents").get().then((querySnapshot) {
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
  await FirebaseFirestore.instance
      .collection("StreamEvents")
      .get()
      .then((querysnapshot) {
    querysnapshot.docs.forEach((element) {
      // print(element.data()['title']);
      streamEventList.add(
          // StreamingEvents.fromJson(json.decode(json.encode(element.data()))));
          StreamingEvents.fromJson(element.data()));
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
