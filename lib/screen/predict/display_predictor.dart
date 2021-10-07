import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/model/preditionlottery.dart';

import 'package:lotto/notifier/prize_notifier.dart';

import 'package:provider/provider.dart';

class DispalyPredictor extends StatefulWidget {
  @override
  _DispalyPredictorState createState() => _DispalyPredictorState();
}

class _DispalyPredictorState extends State<DispalyPredictor> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;

  List<DocumentSnapshot> documents;
  Map<String, String> date = {};
  String dateValue;
  String userDate, newdate;

  @override
  void initState() {
    super.initState();

  }

  getOutDate() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
  }

  bool isBack = true;
  double angle1 = 0, angle2 = 0;

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Color(0xFFF3FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ผลรางวัลฉลากกินแบ่งรัฐบาล",
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'ทำนาย งวดวันที่ ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Mitr")),
                      TextSpan(
                          text: numToWord(prizeNotifier.listOutDate.last),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange,
                              fontFamily: "Mitr")),
                      TextSpan(),
                    ]),
                  ),
                ),
              ),
              // prizeNotifier.predictData.first.name!=null
              //     ? predictByName(prizeNotifier)
              //     : SizedBox(),
              prizeNotifier.prizeList.values.first.data['first'].number[0].value != ""
                  ? predictByCal(
                      Lottoerypredition(
                          //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                          prizeNotifier
                              .prizeList.values.first.data['first'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last2'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3f'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3f'].number[1].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3b'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3b'].number[1].value,
                          "1"),
                    )
                  : SizedBox(),
              prizeNotifier.prizeList.values.first.data['first'].number[0].value != ""
                  ? predictByCal(
                      Lottoerypredition(
                          //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                          prizeNotifier
                              .prizeList.values.first.data['first'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last2'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3f'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3f'].number[1].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3b'].number[0].value,
                          prizeNotifier
                              .prizeList.values.first.data['last3b'].number[1].value,
                          "2"),
                    )
                  : SizedBox(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      )),
    );
  }

  Padding predictByCal(Widget data) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Padding(padding: const EdgeInsets.all(8.0), child: data),
        ),
      ),
    );
  }

  Widget predictByName(PrizeNotifier prizeNotifier) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: prizeNotifier.predictData.map<Widget>((document) {
          return Padding(
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  color: Color(0xFF6390E9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(document.name,
                        style: TextStyle(fontSize: 18, color: Colors.black87)),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 4 / (5 / 4),
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: document.number.split(',').map<Widget>((n) {
                      return Center(
                        child: Text(
                          n,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
