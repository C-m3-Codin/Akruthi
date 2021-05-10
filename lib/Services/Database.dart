import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    db.collection("StreamEvents").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }
}
