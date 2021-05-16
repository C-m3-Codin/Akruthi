import 'package:flutter/material.dart';
import 'package:akruthi/main.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateImage extends StatefulWidget {
  @override
  _DonateImageState createState() => _DonateImageState();
}

class _DonateImageState extends State<DonateImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 167, 0))),
            child: Text(
              "Donate Now",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              String upiurl =
                  'upi://pay?pa=cyril199897@oksbi&pn=SenderName&tn=THanks&am=100&cu=INR';
              await launch(upiurl);
//
              // String upiurl = 'https://discord.gg/Kce6chxm';
              await launch(upiurl);
            }),
        body: Scrollbar(
          isAlwaysShown: true,
          thickness: 20.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/weare.jpg",
                          width: width,
                        ),
                      ),
//                       Positioned(
//                           // top: 2.5 * width,
//                           left: width * .2,
//                           right: width * .2,
//                           bottom: 40,
//                           // alignment: Alignment.bottomCenter,
//                           child: ElevatedButton(
//                               child: Text("Donate".toUpperCase(),
//                                   style: TextStyle(fontSize: 14)),
//                               style: ButtonStyle(
//                                   foregroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.black),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.red),
//                                   shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.zero,
//                                           side:
//                                               BorderSide(color: Colors.red)))),
//                               onPressed: () async {
//                                 String upiurl =
//                                     'upi://pay?pa=cyril199897@oksbi&pn=SenderName&tn=THanks&am=100&cu=INR';
//                                 await launch(upiurl);
// //
//                                 // String upiurl = 'https://discord.gg/Kce6chxm';
//                                 await launch(upiurl);
//                               }))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
