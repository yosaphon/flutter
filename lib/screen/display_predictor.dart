import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/preditionlottery.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/screen/showCheckImage.dart';
import 'dart:math';

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
    super.initState();
    loadData();
  }

  Future loadData() async {
    QuerySnapshot snapAll =
        await FirebaseFirestore.instance.collection('lottery').get();
    setState(() {
      documents = snapAll.docs; //รับทุก docs ใน firebase
      documents.forEach((data) =>
          date[data.id] = data['drawdate']); //เก็บชื่อวัน และ เลขวันเป็น map
      dateValue = date.values.last; //เรียกค่าอันสุดท้าย
    });
  }

  getNumberByNameDate() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
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
                .doc(getNumberByNameDate())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || !snapshot.data.exists) {
                return CircularProgressIndicator();
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _flip1,
                      child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: angle1),
                          duration: Duration(seconds: 1),
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
                                  height:
                                      MediaQuery.of(context).size.height / 2.15,
                                  width:
                                      MediaQuery.of(context).size.width / 2.15,
                                  child: isBack
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image:
                                                  AssetImage("asset/back.png"),
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
                                                image: AssetImage(
                                                    "asset/face.png"),
                                              ),
                                            ),
                                            child: Center(
                                              child: lottoerypredition(
                                                  //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                                                  snapshot.data['result'][0]
                                                      ['number'],
                                                  snapshot.data['result'][3]
                                                      ['number'],
                                                  snapshot.data['result'][1]
                                                      ['number'],
                                                  snapshot.data['result'][2]
                                                      ['number'],
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
                          duration: Duration(seconds: 1),
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
                                  height:
                                      MediaQuery.of(context).size.height / 2.15,
                                  width:
                                      MediaQuery.of(context).size.width / 2.15,
                                  child: isBack
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image:
                                                  AssetImage("asset/back.png"),
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
                                                image: AssetImage(
                                                    "asset/face.png"),
                                              ),
                                            ),
                                            child: Center(
                                              child: lottoerypredition(
                                                  //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                                                  snapshot.data['result'][0]
                                                      ['number'],
                                                  snapshot.data['result'][3]
                                                      ['number'],
                                                  snapshot.data['result'][1]
                                                      ['number'],
                                                  snapshot.data['result'][2]
                                                      ['number'],
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
