import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayLiveYoutube extends StatefulWidget {
  @override
  _DisplayLiveYoutubeState createState() => _DisplayLiveYoutubeState();
}

class _DisplayLiveYoutubeState extends State<DisplayLiveYoutube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ลิงค์ถ่ายทอดสดออกรางวัล"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("LiveLottery")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((document) {
              return Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration:BoxDecoration(
                 borderRadius :BorderRadius.circular(15.0),
                 color: Colors.blue.shade100
                ),
                child: ListTile(
                  leading: FlutterLogo(size: 72.0),
                  title: Text(document["name"]),
                  onTap: () async {
                    if (await canLaunch(document["link"])) {
                      await launch(document["link"]);
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
