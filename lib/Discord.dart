import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
            String upiurl = 'https://discord.com/invite/PUw3Skbt';
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
