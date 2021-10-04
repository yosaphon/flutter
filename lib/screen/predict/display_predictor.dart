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

  getKeyByValue() {
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
                      text: numToWord(prizeNotifier.predictData.date),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          fontFamily: "Mitr")),
                  TextSpan(),
                ]),
              ),
            ),
          ),
          prizeNotifier.predictData.data[0].title != ""
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ListView(
                      children: prizeNotifier.predictData.data
                          .map<Widget>((document) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 5, bottom: 5),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Text(document.title,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black87)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: GridView.count(
                                    crossAxisCount: 4,
                                    childAspectRatio: (90 / 45),
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: document.numbers.map<Widget>((n) {
                                      return Center(
                                        child: Text(
                                          n,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.indigo),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: GridView.count(
                                      crossAxisCount: 4,
                                      childAspectRatio: (90 / 45),
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        Center(
                                          child: Lottoerypredition(
                                              //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['first']
                                                  .number[0]
                                                  .value,
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['last2']
                                                  .number[0]
                                                  .value,
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['last3f']
                                                  .number[0]
                                                  .value,
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['last3f']
                                                  .number[1]
                                                  .value,
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['last3b']
                                                  .number[0]
                                                  .value,
                                              prizeNotifier
                                                  .selectedPrize
                                                  .data['last3b']
                                                  .number[1]
                                                  .value,
                                              "1"),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : Text("รอผลทำนายที่เหลือ"),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottoerypredition(
                      //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                      prizeNotifier.selectedPrize.data['first'].number[0].value,
                      prizeNotifier.selectedPrize.data['last2'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3f'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3f'].number[1].value,
                      prizeNotifier
                          .selectedPrize.data['last3b'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3b'].number[1].value,
                      "1"),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottoerypredition(
                      //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                      prizeNotifier.selectedPrize.data['first'].number[0].value,
                      prizeNotifier.selectedPrize.data['last2'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3f'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3f'].number[1].value,
                      prizeNotifier
                          .selectedPrize.data['last3b'].number[0].value,
                      prizeNotifier
                          .selectedPrize.data['last3b'].number[1].value,
                      "2"),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
