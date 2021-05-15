import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

  Future getSheetData() async {
    print("should come first");
    await http
        .get(Uri.parse(
            "https://script.google.com/macros/s/AKfycbyWh0-nnI1Q5M2LHXjPYxe6SEzPma1KMyu9duTWWXKe_4P3G4cKmL0e0BFWTnrFFASacg/exec"))
        .then((raw) {
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
        child: Text('RULES AND REGULATIONS',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
      )
    ];
    participantWidgets = [];

    for (var rule in eventDetails.rules) {
      ruleWidgets.add(
        Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Card(
              child: ListTile(
                title: Text(rule.desc),
              ),
            ),
          ),
        ),
      );
    }

    for (var participant in eventDetails.participants) {
      participantWidgets.add(
        Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Card(
              child: ListTile(
                title: Text(participant.name),
                subtitle: Text(participant.particulars),
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
              elevation: 5,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 36, vertical: height * .10),
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
                  // color: Theme.of(context).cardColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
                        child: Text('RESULTS',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: Colors.black26,
                          child: ListTile(
                            leading: Icon(Icons.cake_sharp),
                            title: Text(eventDetails.winnerFirst),
                            subtitle: Text(eventDetails.firstParticulars),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: Colors.black26,
                          child: ListTile(
                            leading: Icon(Icons.cake_sharp),
                            title: Text(eventDetails.winnerSecond),
                            subtitle: Text(eventDetails.secondParticulars),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          color: Colors.black26,
                          child: ListTile(
                            leading: Icon(Icons.cake_sharp),
                            title: Text(eventDetails.winnerThird),
                            subtitle: Text(eventDetails.thirdParticulars),
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
              backgroundColor: Colors.yellow,
              elevation: 5,
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 36, vertical: height * .10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
                    child: Text('PARTICIPANTS',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600)),
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
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(children: <Widget>[
      Image.asset(
        "assets/white2.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          // backgroundColor: ,Scaffold(
          body: !loadingComplete
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  ),
                )
              : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(Duration(seconds: 2), () {
                        print('Pull to refresh triggered');
                      });
                    },
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            height: height * .6,
                            width: width,
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: new DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      eventDetails.posterUrl,
                                    ),
                                    // new NetworkImage(widget.event.imageUrl),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            eventDetails.name,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            eventDetails.description,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ),
                        // Text(
                        //   'Rules',
                        //   textAlign: TextAlign.left,
                        //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        // ),
                        TextButton(
                          onPressed: resultDialog,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                Icons.multiple_stop,
                                color: Colors.yellow[50],
                              ),
                              title: Text(
                                'RESULTS',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow),
                              ),
                              tileColor: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          // style: ButtonStyle(

                          //     // backgroundColor: Colors.accents)
                          //     backgroundColor: MaterialStateProperty.all<Color>(
                          //         Colors.yellow)),
                          onPressed: rulesDialog,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                Icons.rule,
                                color: Colors.yellow[50],
                              ),
                              title: Text(
                                'RULES AND REGULATIONS',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow),
                              ),
                              // tileColor: Theme.of(context).backgroundColor,
                              tileColor: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: participantsDialog,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                Icons.multiple_stop,
                                color: Colors.yellow[50],
                              ),
                              title: Text(
                                'PARTICIPANTS',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow),
                              ),
                              tileColor: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Colors.yellow[50],
                              ),
                              title: Text(
                                eventDetails.coordinator1,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.call,
                                          color: Colors.blue[200]),
                                      onPressed: () {
                                        _launchURL(
                                            'tel:+91' + eventDetails.c1Number);
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.message,
                                          color: Colors.green),
                                      onPressed: () {
                                        _launchURL('https://wa.me/+91' +
                                            eventDetails.c1Number);
                                      }),
                                ],
                              ),
                              tileColor: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Colors.yellow[50],
                              ),
                              title: Text(
                                eventDetails.coordinator2,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.call,
                                          color: Colors.blue[200]),
                                      onPressed: () {
                                        _launchURL(
                                            'tel:+91' + eventDetails.c2Number);
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.message,
                                          color: Colors.green),
                                      onPressed: () {
                                        _launchURL('https://wa.me/+91' +
                                            eventDetails.c2Number);
                                      }),
                                ],
                              ),
                              tileColor: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
    ]);
  }
}
