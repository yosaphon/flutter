import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/lotteryData.dart';
import 'package:lotto/model/prizeBox.dart';

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
                      PrizeBox(//รางวัลที่ 1
                          snapshot.data['prizes'][0]['name'],
                          snapshot.data['prizes'][0]['reward'],
                          snapshot.data['prizes'][0]['number']),
                      Row(//รางวัลเลขหน้า, เลขท้าย
                        children: <Widget>[
                          Expanded(
                            child: PrizeBox(
                                snapshot.data['runningNumbers'][0]['name'],
                                snapshot.data['runningNumbers'][0]['reward'],
                                snapshot.data['runningNumbers'][0]['number']),
                          ),
                          Expanded(
                            child: PrizeBox(
                                snapshot.data['runningNumbers'][1]['name'],
                                snapshot.data['runningNumbers'][1]['reward'],
                                snapshot.data['runningNumbers'][1]['number']),
                          ),
                        ],
                      ),
                      PrizeBox(//รางวัลเลขท้าย 2 ตัว
                          snapshot.data['runningNumbers'][2]['name'],
                          snapshot.data['runningNumbers'][2]['reward'],
                          snapshot.data['runningNumbers'][2]['number']),
                      PrizeBox(//รางวัลใกล้เคียง รางวัลที่ 1
                          snapshot.data['prizes'][1]['name'],
                          snapshot.data['prizes'][1]['reward'],
                          snapshot.data['prizes'][1]['number']),
                          PrizeBox(//รางวัลที่ 2
                          snapshot.data['prizes'][2]['name'],
                          snapshot.data['prizes'][2]['reward'],
                          snapshot.data['prizes'][2]['number']),
                          PrizeBox(//รางวัลที่ 3
                          snapshot.data['prizes'][3]['name'],
                          snapshot.data['prizes'][3]['reward'],
                          snapshot.data['prizes'][3]['number']),
                          PrizeBox(//รางวัลที่ 4
                          snapshot.data['prizes'][4]['name'],
                          snapshot.data['prizes'][4]['reward'],
                          snapshot.data['prizes'][4]['number']),
                          PrizeBox(//รางวัลที่ 5
                          snapshot.data['prizes'][5]['name'],
                          snapshot.data['prizes'][5]['reward'],
                          snapshot.data['prizes'][5]['number']),
                    ],
                  );
                }
              }),
        ));
  }
}
