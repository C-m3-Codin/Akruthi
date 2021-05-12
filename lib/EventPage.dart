import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  EventPage({this.event});

  // EventPage event;
  RegEvent event;
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Image.network(widget.event.imageUrl)],
      ),
    ));
  }
}
