import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  EventPage({this.event, this.eventDeets});

  // EventPage event;
  EventDetails eventDeets;
  RegEvent event;
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.event.imageUrl),
            Text(widget.eventDeets.name)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var list = await fetchAlbum(
              "https://script.google.com/macros/s/AKfycbwR3Iv5tCnJYFOZPBsGZFLZdyJdXjFrAxGH2iF-o4AiNwFHsMg71C7UPgCfz2F_WyKDXQ/exec?sheetID=1IiNLptM1TgGBgk1EkHbbsMCZveyFBRDk1IGMSlNNjxo&eventName=event1");

          print("\n\n\n\n\ ${list.toString()} \n\n\n\n\n\n\n\n\n\n");
        },
      ),
    );
  }
}
