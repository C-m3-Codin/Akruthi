import 'package:akruthi/DataModels/StreamEvents.dart';
import 'package:akruthi/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

class HorizontalImages extends StatefulWidget {
  List<StreamingEvents> list;
  HorizontalImages({this.list});
  @override
  _HorizontalImagesState createState() => _HorizontalImagesState();
}

class _HorizontalImagesState extends State<HorizontalImages> {
  @override
  Widget build(BuildContext context) {
    // widget.list.add(widget.list[0]);
    return Container(
      // height: 370.0,
      height: height * .3,
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
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Stack(children: [
                      Stack(
                        children: <Widget>[
                          Center(child: CircularProgressIndicator()),
                          Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: widget.list[index].imageUrl,
                            ),
                          ),
                        ],
                      ),
                      widget.list[index].happening == "Yes"
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Live ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        Icon(
                                          Icons.live_tv,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
