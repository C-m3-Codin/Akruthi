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
          StreamingEvents.fromJson(json.decode(json.encode(element.data()))));
    });
  });

  // print('retrieved: ${postFromFirebase.eventName}');
  return streamEventList;
}

Future<List<StreamingEvents>> generalEventList() async {
  List<StreamingEvents> streamEventList = [];
  // print(postPath);
  print("\n\n");
  await FirebaseFirestore.instance
      .collection("generalEvents")
      .get()
      .then((querysnapshot) {
    querysnapshot.docs.forEach((element) {
      // print(element.data()['title']);
      streamEventList.add(
          StreamingEvents.fromJson(json.decode(json.encode(element.data()))));
    });
  });

  // print('retrieved: ${postFromFirebase.eventName}');
  return streamEventList;
}
