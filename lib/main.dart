import 'dart:ui';

import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:akruthi/LiveStreams.dart';
import 'package:akruthi/NotificationTry.dart';
import 'package:akruthi/Services/Database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
// import 'package:overlay_support/overlay_support.dart';

// FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<StreamingEvents> list = [];
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
            child: Scaffold(

                // appBar: AppBar(
                //   title: Text("bam"),
                // ),
                body: Container(
                    child: new SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: [
                            HorizontalImages(list: list),

                            SizedBox(
                              height: height * .010,
                            ),
                            CmReliefFund(),

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
                                  "OtherEvents ${list.length}",
                                  style: TextStyle(fontSize: 40),
                                ),
                              ),
                            ),

                            // Expanded(
                            // child:
                            // ListView.builder(
                            //     // physics: NeverScrollableScrollPhysics(),
                            //     // shrinkWrap: true,
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     itemCount: list.length,
                            //     itemBuilder: (BuildContext context, index) {
                            //       if (index == 4) {
                            //         return Column(
                            //           children: [
                            //             DiscordJoin(),
                            //             ListTile(
                            //               title: Text(list[index].eventName),
                            //             )
                            //           ],
                            //         );
                            //       }
                            //       return ListTile(
                            //         title: Text(list[index].eventName),
                            //       );
                            //     }),

                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: 2,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  ((list.length) * .5).round(), (index) {
                                return EachEvent(list: list, ind: index);
                              }),
                            ),

                            DiscordJoin(),

                            GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: 2,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  ((list.length) * .5).toInt(), (index) {
                                int ind = (list.length * .5).toInt() + index;
                                return EachEvent(list: list, ind: ind);
                              }),
                            ),

                            // )
                          ],
                        )))),
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

  final List<StreamingEvents> list;
  final int ind;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(list[ind].imageUrl),
                  fit: BoxFit.cover)),
          child: new Center(
            child: new ClipRect(
              child: new SizedBox(
                height: 200.0,
                width: 200.0,
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(
                    sigmaX: 2.0,
                    sigmaY: 2.0,
                  ),
                  child: new Center(
                    child: new Text(
                      list[ind].eventName,
                      style: TextStyle(color: Colors.amber[600]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        //  Stack(
        //   children: [
        //     Image.network(
        //       list[index].imageUrl,
        //       height: 200,
        //       width: 200,
        //       fit: BoxFit.cover,
        //     ),
        //     Container(
        //       height: 200,
        //       width: 200,
        //       // width: _width,
        //       // height: _height,
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(
        //             sigmaX: 0.60, sigmaY: 0.60),
        //         // ImageFilter.blur(
        //         // sigmaX: 0.0, sigmaY: 0.0),
        //         child: Container(
        //           color:
        //               Colors.black.withOpacity(.10),
        //         ),
        //       ),
        //     ),
        //     Text(
        //         'Item ${(list.length * .5).toInt() + index}',
        //         style:
        //             TextStyle(color: Colors.red)),
        //   ],
        // ),
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
        style: ElevatedButton.styleFrom(primary: Colors.white),
        onPressed: () async {
          String upiurl =
              'upi://pay?pa=user@hdfgbank&pn=SenderName&tn=TestingGpay&am=100&cu=INR';
          await launch(upiurl);
        },
        child: Container(
          height: height * .08,
          child: Image.network(
            "https://firebasestorage.googleapis.com/v0/b/akruthi-e3f25.appspot.com/o/discord.png?alt=media&token=764993f7-2270-4315-a464-93854179a458",
            fit: BoxFit.cover,
          ),
        ));
  }
}

class CmReliefFund extends StatelessWidget {
  const CmReliefFund({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 20,
            // minimumSize: Size,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            primary: Colors.yellow),
        onPressed: () async {
          String upiurl =
              'upi://pay?pa=user@hdfgbank&pn=SenderName&tn=TestingGpay&am=100&cu=INR';
          await launch(upiurl);
        },
        child: Text(
          "Donate to CM Relief Fund",
          style: TextStyle(color: Colors.black),
        ));
  }
}
