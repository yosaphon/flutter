import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/model/preditionlottery.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/showCheckImage.dart';
import 'dart:math';

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

  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);

    loadData(prizeNotifier);
    super.initState();
  }

  getKeyByValue() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
  }

  Future loadData(PrizeNotifier prizeNotifier) async {
    await getPrize(prizeNotifier);
      prizeNotifier.prizeList.forEach((key, value) =>
          date[key] = value.date); //เก็บชื่อวัน และ เลขวันเป็น map
      dateValue = date.values.first; //เรียกค่าอันสุดท้าย});
      prizeNotifier.selectedPrize = prizeNotifier.prizeList[getKeyByValue()];
  }

  bool isBack = true;
  double angle1 = 0, angle2 = 0;

  void _flip1() {
    setState(() {
      angle1 = (angle1 + pi) % (2 * pi);
    });
  }

  void _flip2() {
    setState(() {
      angle2 = (angle2 + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFF3FFFE),
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
        backgroundColor: Color(0xFF25D4C2),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (prizeNotifier.prizeList.isEmpty) {
            return CircularProgressIndicator();
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _flip1,
                  child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: angle1),
                      duration: Duration(milliseconds: 400),
                      builder: (BuildContext context, double val, __) {
                        //here we will change the isBack val so we can change the content of the card
                        if (val >= (pi / 2)) {
                          isBack = false;
                        } else {
                          isBack = true;
                        }
                        return (Transform(
                          //let's make the card flip by it's center
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(val),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.15,
                              width: MediaQuery.of(context).size.width / 2.15,
                              child: isBack
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: AssetImage("asset/back.png"),
                                        ),
                                      ),
                                    ) //if it's back we will display here
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(
                                            pi), // it will flip horizontally the container
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: AssetImage("asset/face.png"),
                                          ),
                                        ),
                                        child: Center(
                                          child: lottoerypredition(
                                              //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                                              prizeNotifier.selectedPrize.data['first'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last2'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3f'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3f'].number[1].value,
                                              prizeNotifier.selectedPrize.data['last3b'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3b'].number[1].value,
                                              "1"),
                                        ),
                                      ),
                                    ) //else we will display it here,
                              ),
                        ));
                      }),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _flip2,
                  child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: angle2),
                      duration: Duration(milliseconds: 400),
                      builder: (BuildContext context, double val, __) {
                        //here we will change the isBack val so we can change the content of the card
                        if (val >= (pi / 2)) {
                          isBack = false;
                        } else {
                          isBack = true;
                        }
                        return (Transform(
                          //let's make the card flip by it's center
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(val),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.15,
                              width: MediaQuery.of(context).size.width / 2.15,
                              child: isBack
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: AssetImage("asset/back.png"),
                                        ),
                                      ),
                                    ) //if it's back we will display here
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(
                                            pi), // it will flip horizontally the container
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: AssetImage("asset/face.png"),
                                          ),
                                        ),
                                        child: Center(
                                          child: lottoerypredition(
                                              //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                                              prizeNotifier.selectedPrize.data['first'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last2'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3f'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3f'].number[1].value,
                                              prizeNotifier.selectedPrize.data['last3b'].number[0].value,
                                              prizeNotifier.selectedPrize.data['last3b'].number[1].value,
                                              "2"),
                                        ),
                                      ),
                                    ) //else we will display it here,
                              ),
                        ));
                      }),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
