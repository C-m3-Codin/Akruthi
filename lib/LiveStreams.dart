import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:akruthi/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalImages extends StatefulWidget {
  List<StreamingEvents> list;
  HorizontalImages({this.list});
  @override
  _HorizontalImagesState createState() => _HorizontalImagesState();
}

class _HorizontalImagesState extends State<HorizontalImages> {
  @override
  Widget build(BuildContext context) {
    widget.list.add(widget.list[0]);
    return Container(
      // height: 370.0,
      height: height * .4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.list.length,
        itemBuilder: (BuildContext cotext, int index) {
          return GestureDetector(
            onTap: () async {
              String upiurl = widget.list[index].redirectUrl;
              if (widget.list[index].happening == "Yes")
                await launch(upiurl);
              else
                AwesomeDialog(
                  context: context,
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  width: 280,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'Event Not Started',
                  desc: 'Stay Tuned...',
                  // showCloseIcon: true,
                  // btnCancelOnPress: () {},
                  btnOkOnPress: () {},
                )..show();
            },
            child: Stack(children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(children: [
                      Image.network(widget.list[index].imageUrl),
                      widget.list[index].happening == "Yes"
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  "Live ",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Icon(
                                  Icons.live_tv,
                                  color: Colors.red,
                                )
                              ],
                            )
                          : Container(),
                    ])),
              ),
            ]),
          );
        },
      ),
    );
  }
}
