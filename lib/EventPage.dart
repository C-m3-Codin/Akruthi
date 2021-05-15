import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  EventPage({this.event, this.eventDeets});

  // EventPage event;
  EventDetails eventDeets;
  RegEvent event;
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<String> rules = ['rule 1', 'rule2', 'rule3', 'rule2', 'rule3'];
  List<String> participantNames = [
    'participant1',
    'participant2',
    'participant3',
    'participant4',
    'participant1',
    'participant2',
    'participant3',
    'participant1',
    'participant2',
    'participant3',
  ];
  List<Widget> ruleWidgets = [];
  List<Widget> participantWidgets = [];
  String c1name = 'Cyril Paul',
      c1number = '9207585032',
      c2name = 'Cyril Paul',
      c2number = '9207585032';

  var width;
  var height;

  setupWidgets() {
    ruleWidgets = [
      Padding(
        padding: EdgeInsets.fromLTRB(10, 22, 10, 18),
        child: Text('RULES AND REGULATIONS',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
      )
    ];
    participantWidgets = [];

    for (var rule in rules) {
      ruleWidgets.add(
        Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Card(
              child: ListTile(
                title: Text(
                    'yeah there yeah there yeah there yeah there yeah there yeah there yeah there yeah there yeah there yeah there'),
              ),
            ),
          ),
        ),
      );
    }

    for (var participant in participantNames) {
      participantWidgets.add(
        Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Card(
              child: ListTile(
                title: Text(participant),
                subtitle: Text(participant),
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
  Widget build(BuildContext context) {
    setupWidgets();
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
          body: SafeArea(
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
                      height: height * .5,
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
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.event.eventName,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Description goes here Description goes here Description goes here Descripon goes here Desction goes herription goes here Description goes here ',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                  // Text(
                  //   'Rules',
                  //   textAlign: TextAlign.left,
                  //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  // ),
                  TextButton(
                    style: ButtonStyle(

                        // backgroundColor: Colors.accents)
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow)),
                    onPressed: rulesDialog,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        leading: Icon(
                          Icons.rule,
                          color: Colors.blue[50],
                        ),
                        title: Text(
                          'RULES AND REGULATIONS',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        // tileColor: Theme.of(context).backgroundColor,
                        tileColor: Colors.yellow[700],
                      ),
                    ),
                  ),

                  // ExpandablePanel(
                  //   header: Text('RULES AND REGULATIONS'),
                  //   collapsed: Text(
                  //     "TEsting",
                  //     softWrap: true,
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  //   expanded: Text(
                  //     article.body,
                  //     softWrap: true,
                  //   ),
                  //   tapHeaderToExpand: true,
                  //   hasIcon: true,
                  // ),

                  TextButton(
                    onPressed: participantsDialog,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        leading: Icon(
                          Icons.multiple_stop,
                          color: Colors.blue[50],
                        ),
                        title: Text(
                          'PARTICIPANTS',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        tileColor: Theme.of(context).backgroundColor,
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
                          color: Colors.blue[50],
                        ),
                        title: Text(
                          c1name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.call, color: Colors.blue[200]),
                                onPressed: () {
                                  _launchURL('tel:+91' + c1number);
                                }),
                            IconButton(
                                icon: Icon(Icons.message, color: Colors.green),
                                onPressed: () {
                                  _launchURL('https://wa.me/+91' + c1number);
                                }),
                          ],
                        ),
                        tileColor: Theme.of(context).backgroundColor,
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
                          color: Colors.blue[50],
                        ),
                        title: Text(
                          c1name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.call, color: Colors.blue[200]),
                                onPressed: () {}),
                            IconButton(
                                icon: Icon(Icons.message, color: Colors.green),
                                onPressed: () {}),
                          ],
                        ),
                        tileColor: Theme.of(context).backgroundColor,
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
