import 'dart:ui';

import 'package:akruthi/DataModels/EventDetail.dart';
import 'package:akruthi/DataModels/RegEvent.dart';
import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:akruthi/EventPage.dart';
import 'package:akruthi/LiveStreams.dart';
import 'package:akruthi/ScoreCard.dart';
// import 'package:akruthi/NotificationTry.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
// import 'package:overlay_support/overlay_support.dart';

// FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// String ass = "appp";
double width;
double height;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// / Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MApp());
}

class MApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: ThemeData.dark(), home: MyApp());
  }
}

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
                backgroundColor: Colors.black,
                // backgroundColor: ,

                floatingActionButton: FloatingActionButton(
                  // backgroundColor: Colors.yellow[700],

                  child: CircleAvatar(
                    backgroundColor: Colors.yellow[700],
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

                            Container(
                              // color: Colors.green,
                              child: Center(
                                child: Text(
                                  "OtherEvents ${regularEvent.length}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),

                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 10 / 14,

                              // main
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  ((regularEvent.length) * .5).round(),
                                  (index) {
                                return EachEvent(
                                    list: regularEvent, ind: index);
                              }),
                            ),

                            DiscordJoin(),

                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 10 / 14,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  ((regularEvent.length) * .5).toInt(),
                                  (index) {
                                int ind =
                                    (regularEvent.length * .5).toInt() + index;
                                return EachEvent(
                                    list: regularEvent, ind: index);
                              }),
                            ),

                            // )
                          ],
                        )))),
          ]));
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
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueAccent,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.,
                children: [
                  // Expanded(
                  // child:
                  Container(
                    color: Colors.blue,
                    // height: height * .1,
                    // width: width * .7,
                    // decoration: new BoxDecoration(
                    //     // color: Colors.blue,

                    //     borderRadius: BorderRadius.circular(5.0),
                    //     image: new DecorationImage(
                    //         image: CachedNetworkImageProvider(
                    //           list[ind].imageUrl,
                    //         ),
                    //         //  new NetworkImage(list[ind].imageUrl),
                    //         fit: BoxFit.fill)),

                    child: Image(
                        // height: 20,
                        image: CachedNetworkImageProvider(
                          list[ind].imageUrl,
                        ),
                        fit: BoxFit.cover),
//
                    //  new Center(
                    //   child: new ClipRect(
                    //     child: new SizedBox(
                    //       height: height * .3,
                    //       width: width * .5,
                    //       child: new BackdropFilter(
                    //         filter: new ImageFilter.blur(
                    //             // sigmaX: 2.0,
                    //             // sigmaY: 2.0,
                    //             ),
                    //         child: new Center(
                    //           child: BorderedText(
                    //             strokeWidth: 4.0,
                    //             // strokeColor: Color(0xF2AA4CFF),
                    //             strokeColor: Colors.black,
                    //             child: Text(
                    //               "",
                    //               // list[ind].eventName,
                    //               style: TextStyle(
                    //                 shadows: [
                    //                   Shadow(
                    //                     blurRadius: 10.0,
                    //                     // color: Colors.red,
                    //                     offset: Offset(5.0, 10.0),
                    //                   ),
                    //                 ],
                    //                 color: Colors.yellow[700],
                    //                 // fontWeight: FontWeight.bold,
                    //                 fontSize: 13.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),

                    //  new Text(
                    // list[ind].eventName,
                    // style: TextStyle(color: Colors.amber[600]),
                    // ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  // ),
                  // SizedBox(
                  // height: 10,
                  // ),
                  Container(
                    child: Text(list[ind].eventName),
                  )
                ],
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
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 20,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            // primary: Colors.yellow[700]),
            primary: Colors.yellow[700]),
        onPressed: () async {
          String upiurl = 'https://discord.gg/795n5nhP';
          await launch(upiurl);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Join Our Discord",
              style: TextStyle(color: Colors.black),
            ),
            Image.asset('assets/disc.png', width: 45)
          ],
        ));
  }
}

class CmReliefFund extends StatelessWidget {
  const CmReliefFund({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //         elevation: 20,
    //         shape: new RoundedRectangleBorder(
    //           borderRadius: new BorderRadius.circular(30.0),
    //         ),
    //         // primary: Colors.yellow[700]),
    //         primary: Colors.red),
    //     onPressed: () async {
    //       String upiurl =
    //           'upi://pay?pa=user@hdfgbank&pn=SenderName&tn=TestingGpay&am=100&cu=INR';
    //       await launch(upiurl);
    //       // String upiurl = 'https://discord.gg/Kce6chxm';
    //       // await launch(upiurl);
    //     },
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         Text(
    //           "Donate to CM Relief Fund",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         // Image.asset('assets/disc.png', width: 45)
    //       ],
    //     ));

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
                "Donate to CM Relief Fund",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
