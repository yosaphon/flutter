import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayLiveYoutube extends StatefulWidget {
  @override
  _DisplayLiveYoutubeState createState() => _DisplayLiveYoutubeState();
}

class _DisplayLiveYoutubeState extends State<DisplayLiveYoutube> {
  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    getPrize(prizeNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFF3FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ลิงค์ถ่ายทอดสด",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Color(0xFF25D4C2),
        elevation: 0,
      ),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (prizeNotifier.prizeList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: prizeNotifier.prizeList.values.map((document) {
              return Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.blue.shade100),
                child: ListTile(
                  leading: Container(
                    width: 75,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              'asset/YouTube_full-color_icon.svg.png')),
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      color: Colors.redAccent,
                    ),
                  ),
                  title: Text("วันที่ ${document.date} งวดที่ ${document.period[0]},${document.period[1]}" ),
                  onTap: () async {
                    if (await canLaunch(document.youtubeUrl)) {
                      await launch(document.youtubeUrl);
                    }
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
