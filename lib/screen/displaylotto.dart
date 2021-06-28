import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/lotteryData.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //สร้าง List ไว้เก็บ Lottery
  List<dynamic> lotteryList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //ดึงข้อมูล
  Future loadData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Lottery')
        .doc('25640616')
        .get();

    //สร้าง obj  จากคลาส LotteryData เอาข้อมูลใส่
    LotteryData lottery = LotteryData.fromJson(snapshot.data());//ไม่ได้ ทำไม่เป็น
    lotteryList.add(lottery);//เพิ่มลง List
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "หน้าแรก",
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
            child: Text(
          lotteryList[0]??'ค่ามันว่าง',
          style: TextStyle(color: Colors.red, fontSize: 25),
        )));
  }
}
