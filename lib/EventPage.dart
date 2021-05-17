import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventPage extends StatefulWidget {
  EventPage({this.event, this.eventDeets});

  // EventPage event;
  EventDetails eventDeets;
  RegEvent event;
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool loadingComplete = false;
  List<Widget> ruleWidgets = [];
  List<Widget> participantWidgets = [];
  var width;
  var height;
  EventDetails eventDetails;

  Color tileColor = Color.fromARGB(255, 255, 167, 0);
  Color bgColor = Colors.black;
  Color tileTextColor = Colors.black;
  Color iconColor = Colors.black;
  Color dialogTileColor = Color.fromARGB(255, 255, 167, 0);
  double textScaleFactor = 0.83;
  double fontSize = 18;

  Future getSheetData() async {
    print("should come first");

    await http.get(Uri.parse(
        // "https://script.google.com/macros/s/AKfycbyWh0-nnI1Q5M2LHXjPYxe6SEzPma1KMyu9duTWWXKe_4P3G4cKmL0e0BFWTnrFFASacg/exec")

        widget.event.sheet)).then((raw) {
      print(widget.event.sheet);
      var jsonEvent = convert.jsonDecode(raw.body);
      eventDetails = EventDetails.fromJson(jsonEvent);
      print(eventDetails.name);
      setState(() {
        loadingComplete = true;
      });

      return eventDetails;
    });

    print("last");
  }

  setupWidgets() {
    ruleWidgets = [
      Padding(
        padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
        child: AutoSizeText('RULES AND REGULATIONS',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: tileColor)),
      )
    ];
    participantWidgets = [];

    for (var rule in eventDetails.rules) {
      ruleWidgets.add(
        Material(
          color: bgColor,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Card(
              child: ListTile(
                tileColor: dialogTileColor,
                title: Text(
                  rule.desc,
                  style: TextStyle(color: tileTextColor),
                ),
              ),
            ),
          ),
        ),
      );
    }

    for (var participant in eventDetails.participants) {
      // print(participant.name);
      participantWidgets.add(
        Material(
          color: bgColor,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Card(
              child: ListTile(
                tileColor: dialogTileColor,
                title: Text(
                  participant.name,
                  style: TextStyle(
                      color: tileTextColor, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  participant.particulars,
                  style: TextStyle(color: tileTextColor),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  rulesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: bgColor,
              elevation: 5,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: height * .10),
              child: SingleChildScrollView(
                child: Container(
                  // color: Theme.of(context).cardColor,
                  child: Column(
                    children: ruleWidgets,
                  ),
                ),
              ));
        });
  }

  resultDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 5,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 36, vertical: height * .10),
              child: SingleChildScrollView(
                child: Container(
                  color: bgColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
                        child: Text('RESULTS',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: tileColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: dialogTileColor,
                          child: ListTile(
                            leading: Icon(Icons.star, size: 32),
                            title: Text(eventDetails.winnerFirst,
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(eventDetails.firstParticulars,
                                style: TextStyle(color: bgColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: dialogTileColor,
                          child: ListTile(
                            leading: Icon(Icons.star, size: 32),
                            title: Text(eventDetails.winnerSecond,
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(eventDetails.secondParticulars,
                                style: TextStyle(color: bgColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: dialogTileColor,
                          child: ListTile(
                            leading: Icon(Icons.star, size: 32),
                            title: Text(eventDetails.winnerThird,
                                style: TextStyle(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(eventDetails.thirdParticulars,
                                style: TextStyle(color: bgColor)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  participantsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: bgColor,
              elevation: 5,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 36, vertical: height * .10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
                    child: Text('PARTICIPANTS',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: tileColor)),
                  ),
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: participantWidgets,
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  _launchURL(String url) async {
    await launch(url);
  }

  @override
  void initState() {
    getSheetData().then((_) {
      setupWidgets();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(children: <Widget>[
      Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: getSheetData,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Visibility(
                    visible: widget.event.imageUrl.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        height: height * .65,
                        width: width,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: new DecorationImage(
                                image: CachedNetworkImageProvider(
                                  widget.event.imageUrl,
                                ),
                                // new NetworkImage(widget.event.imageUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  !loadingComplete
                      ? Container(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: CircularProgressIndicator(
                                backgroundColor: tileColor,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: eventDetails.name.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  eventDetails.name,
                                  textScaleFactor: textScaleFactor,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: tileColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.date.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Icon(
                                        Icons.date_range,
                                        size: 18,
                                      ),
                                    ),
                                    Text(
                                      eventDetails.date,
                                      textScaleFactor: textScaleFactor,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.description.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  eventDetails.description,
                                  textScaleFactor: textScaleFactor,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: eventDetails.resultsAnnounced == 'yes'
                                  ? resultDialog
                                  : () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  trailing: eventDetails.resultsAnnounced ==
                                          'no'
                                      ? Icon(Icons.close, color: Colors.black)
                                      : Icon(Icons.check, color: Colors.black),
                                  leading: Icon(
                                    Icons.multiple_stop,
                                    color: iconColor,
                                  ),
                                  title: Text(
                                    'RESULTS',
                                    // textScaleFactor: textScaleFactor,
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: tileTextColor),
                                  ),
                                  tileColor: tileColor,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.rules.isNotEmpty,
                              child: TextButton(
                                onPressed: rulesDialog,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.rule,
                                      color: iconColor,
                                    ),
                                    title: AutoSizeText(
                                      'RULES AND REGULATIONS ',
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: tileTextColor),
                                      maxLines: 1,
                                    ),

                                    // Text(
                                    //   'RULES AND REGULATIONS',
                                    //   textScaleFactor: textScaleFactor,
                                    //   style: TextStyle(
                                    //       fontSize: 20,
                                    //       fontWeight: FontWeight.bold,
                                    //       color: tileTextColor),
                                    // ),
                                    // tileColor: Theme.of(context).backgroundColor,
                                    tileColor: tileColor,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.participants.isNotEmpty,
                              child: TextButton(
                                onPressed: participantsDialog,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.multiple_stop,
                                      color: iconColor,
                                    ),
                                    title: Text(
                                      'PARTICIPANTS',
                                      // textScaleFactor: textScaleFactor,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: tileTextColor),
                                    ),
                                    tileColor: tileColor,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.coordinator1.isNotEmpty,
                              child: TextButton(
                                onPressed: null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: iconColor,
                                    ),
                                    title: AutoSizeText(
                                      eventDetails.coordinator1.toUpperCase(),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: tileTextColor),
                                    ),
                                    trailing: Visibility(
                                      visible: eventDetails.c2Number.isNotEmpty,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.call,
                                                  color: iconColor),
                                              onPressed: () {
                                                _launchURL('tel:+91' +
                                                    eventDetails.c1Number);
                                              }),
                                          IconButton(
                                              icon: Icon(Icons.message,
                                                  color: iconColor),
                                              onPressed: () {
                                                _launchURL('https://wa.me/+91' +
                                                    eventDetails.c1Number);
                                              }),
                                        ],
                                      ),
                                    ),
                                    tileColor: tileColor,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: eventDetails.coordinator2.isNotEmpty,
                              child: TextButton(
                                onPressed: null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: iconColor,
                                    ),
                                    title: AutoSizeText(
                                      eventDetails.coordinator2.toUpperCase(),
                                      maxLines: 1,
                                      // textScaleFactor: textScaleFactor,
                                      // "asdasdasdasdasdasdasdasdasdasdasdasdasdasd",
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: tileTextColor),
                                    ),
                                    trailing: Visibility(
                                      visible: eventDetails.c2Number.isNotEmpty,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.call,
                                                  color: iconColor),
                                              onPressed: () {
                                                _launchURL('tel:+91' +
                                                    eventDetails.c2Number);
                                              }),
                                          IconButton(
                                              icon: Icon(Icons.message,
                                                  color: iconColor),
                                              onPressed: () {
                                                _launchURL('https://wa.me/+91' +
                                                    eventDetails.c2Number);
                                              }),
                                        ],
                                      ),
                                    ),
                                    tileColor: tileColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ))
    ]);
  }
}
