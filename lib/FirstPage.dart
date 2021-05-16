import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/EventPage.dart';
import 'package:akruthi/main.dart';
import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:akruthi/LiveStreams.dart';
import 'package:akruthi/ScoreCard.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<StreamingEvents> list = [];
  List<RegEvent> regularEvent = [];
  QuerySnapshot querySnapshot;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      streamingEvents().then((value) {
        list = value;
        setState(() {});
      });

      print("done List");

      generalEventList().then((value) {
        regularEvent = value;
        setState(() {});
      });
    });

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return list.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Stack(children: <Widget>[
            Image.asset(
              "assets/white2.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Scaffold(
                // backgroundColor: Color.fromARGB(255, 37, 30, 62),
                // backgroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 1, 31, 75),
                floatingActionButton: FloatingActionButton(
                  // backgroundColor: Colors.yellow[700],

                  child: CircleAvatar(
                    backgroundColor: Colors.yellow[900],
                    radius: 100,
                    child: Image.asset('assets/prize.png', width: 30),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ScoreCard()));
                  },
                ),
                body: Container(
                    padding: EdgeInsets.all(10),
                    child: new SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            CmReliefFund(),
                            HorizontalImages(list: list),

                            SizedBox(
                              height: height * .010,
                            ),

                            DiscordJoin(),

                            // DiscordJoin(),
                            //   ],
                            // ),
                            SizedBox(
                              height: height * .010,
                            ),

                            eventHeader(),

                            gridViewEvents(),
                          ],
                        )))),
          ]));
  }

  GridView gridViewEvents() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 10 / 14,

      // main
      // Generate 100 widgets that display their index in the List.
      children: List.generate(regularEvent.length, (index) {
        return EachEvent(list: regularEvent, ind: index);
      }),
    );
  }

  Padding eventHeader() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        // color: Colors.green,
        child: Center(
          child: Text(
            "Events ${regularEvent.length}",
            style: GoogleFonts.abrilFatface(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("\n\n\ Received FCM token:$token");
  }
}

class EachEvent extends StatelessWidget {
  const EachEvent({
    Key key,
    @required this.list,
    @required this.ind,
  }) : super(key: key);

  final List<RegEvent> list;
  final int ind;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // EventDetails eventDeets = await fetchAlbum(list[ind].sheet);
        EventDetails eventDeets = new EventDetails();
        print("\n\n\n\n\ ${list.toString()} \n\n\n\n\n\n\n\n\n\n");

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EventPage(event: list[ind], eventDeets: eventDeets)),
        );
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(020),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(010),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 167, 0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      // child:
                      Container(
                        color: Colors.blue,

                        child: Center(
                          child: Image(

                              // height: 20,
                              image: CachedNetworkImageProvider(
                                list[ind].imageUrl,
                              ),
                              fit: BoxFit.cover),
                        ),

//
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          child: Text(
                            list[ind].eventName,
                            style: GoogleFonts.montserrat(
                                color: Colors.black, fontSize: 10.0
                                // fontSize: 15,
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscordJoin extends StatelessWidget {
  const DiscordJoin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 20,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              primary: Color.fromARGB(255, 255, 167, 0)),
          // primary: Color.fromARGB(255, 238, 64, 53)),
          onPressed: () async {
            String upiurl = 'https://discord.gg/795n5nhP';
            await launch(upiurl);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                " Join Discord ",
                // style: TextStyle(color: Color.fromARGB(255, 5, 30, 62)),
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Image.asset('assets/disc.png', width: 45)
            ],
          )),
    );
  }
}

class CmReliefFund extends StatelessWidget {
  const CmReliefFund({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String upiurl =
            'upi://pay?pa=cyril199897@oksbi&pn=SenderName&tn=THanks&am=100&cu=INR';
        await launch(upiurl);
        // String upiurl = 'https://discord.gg/Kce6chxm';
        // await launch(upiurl);
      },
      child: Container(
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Donate for a good cause",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}