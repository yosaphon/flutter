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
      extendBodyBehindAppBar: true,
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
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
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
                          image: AssetImage('asset/YouTube_full-color_icon.svg.png')),
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      color: Colors.redAccent,
                    ),
                  ),
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
