import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
