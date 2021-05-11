import 'package:akruthi/DataModels/StreamEvents.dart';
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
    // DatabaseServices ab = new DatabaseServices();
    // DatabaseServices ab = new DatabaseServices();
    // list = geStreamEvents();

    // print("\n\n\n\n\nEachEvent ${list[0].eventName}");
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
                body: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: height * .3,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (a, b) => print("asd"),
                    scrollDirection: Axis.horizontal,
                  ),
                  items: list.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () async {
                            // () async {
                            await launch(i.redirectUrl);
                            // },
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(color: Colors.amber),
                                child: Image.network(
                                  i.imageUrl,
                                  // width: width * .4,
                                  fit: BoxFit.cover,
                                )),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: height * .010,
                ),

                GestureDetector(
                    onTap: () async {
                      // () async {
                      await launch('https://discord.gg/QkkDwuC86w');
                      // },
                    },
                    child: Container(
                      height: height * .08,
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/akruthi-e3f25.appspot.com/o/discord.png?alt=media&token=764993f7-2270-4315-a464-93854179a458",
                        fit: BoxFit.cover,
                      ),
                    )),
                //   ],
                // ),
                SizedBox(
                  height: height * .010,
                ),

                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "OtherEvents",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          title: Text(list[index].eventName),
                        );
                      }),
                )
              ],
            )),
          );
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("\n\n\ Received FCM token:$token");
  }
}
