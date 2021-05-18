import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:akruthi/main.dart';
// import 'package:main.dart';

import 'DataModels/ScoreCardModel.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class ScoreCard extends StatefulWidget {
  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  List<Score> scores = [];
  Future getSheetData() async {
    print("sending req");
    return await http.get(Uri.parse(resultUrl)).then((raw) {
      // print(raw.body);

      scores =
          List<Score>.from(json.decode(raw.body).map((x) => Score.fromJson(x)));
      print(scores[10].scoreClass);
      scores.sort((a, b) => b.points.compareTo(a.points));
      print(scores[10].scoreClass);

      setState(() {});
    });
  }

  @override
  void initState() {
    getSheetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List difference = [];
    return Stack(children: <Widget>[
      // Image.asset(
      //   "assets/white2.jpg",
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   fit: BoxFit.cover,
      // ),
      Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Score Board")),
        backgroundColor: Colors.black,
        body: RefreshIndicator(
          onRefresh: getSheetData,
          child: scores.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    if (index != 0) {
                      var dif = scores[index].points - scores[index - 1].points;
                      if (dif == 0) {
                        dif = difference[index - 1];
                      }
                      difference.add(dif);
                    } else {
                      difference.add(0);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6),
                      child: Card(
                        color: Colors.black,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            tileColor: Color.fromARGB(255, 255, 167, 0),
                            leading: scores[index].points == scores[0].points
                                ? Icon(
                                    Icons.stars,
                                    color: Colors.white,
                                  )
                                : index < 3
                                    ? Icon(Icons.star_outline)
                                    : SizedBox(),
                            title: BorderedText(
                              strokeWidth: 1.0,
                              strokeColor: Colors.black,
                              child: Text(
                                scores[index].scoreClass,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    // decorationColor: Colors.red,
                                    letterSpacing: 2.0),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                      // backgroundColor: Theme.of(context).,
                                      child: Text(
                                          scores[index].points.toString())),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: BorderedText(
                                      strokeWidth: 2.0,
                                      strokeColor: Colors.black54,
                                      child: Text(
                                        difference[index] != 0
                                            ? (difference[index] * -1)
                                                    .toString() +
                                                '↓'
                                            : '    ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.red[800],
                                            fontSize: 20,
                                            letterSpacing: 2.0),
                                      ),
                                    )

                                    // Text(
                                    //   difference[index] != 0
                                    //       ? (difference[index] * -1).toString() + '↓'
                                    //       : '   -',
                                    //   style: TextStyle(
                                    //       color: Colors.red,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      )
    ]);
  }
}
