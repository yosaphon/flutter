import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/lotteryData.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ผลรางวัลฉลากกินแบ่งรัฐบาล",
            style: TextStyle(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          // backgroundColor: Colors.transparent,
          backgroundColor: Colors.black.withOpacity(0.1),
          elevation: 0,
        ),
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('lottery')
                  .doc('25640616')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Text(
                          snapshot.data['date'],
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text('รางวัลที่ 1'),
                            Text('รางวัลละ 6,000,000 บาท'),
                            Center(
                              child: GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                shrinkWrap: true,
                                children: snapshot.data['prizes'][0]['number']
                                    .map<Widget>((a) {
                                  return Text(a);
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),Container(
                        child: Column(
                          children: [
                            Text('รางวัลที่ 5'),
                            Text('รางวัลละ 6,000,000 บาท'),
                            Center(
                              child: GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                shrinkWrap: true,
                                children: snapshot.data['prizes'][4]['number']
                                    .map<Widget>((a) {
                                  return Text(a);
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }
}
