import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lotto/api/user_api.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class ShowPurchaseReport extends StatefulWidget {
  final dateuser; // filter สำหรับหาวันที่
  const ShowPurchaseReport({this.dateuser});

  @override
  _ShowPurchaseReportState createState() => _ShowPurchaseReportState(dateuser);
}

class _ShowPurchaseReportState extends State<ShowPurchaseReport> {
  final user = FirebaseAuth.instance.currentUser;
  final dateuser;
  List<dynamic> allresultdate = [];
  _ShowPurchaseReportState(this.dateuser);
  String totalProfit, totalWon, totalLose, totalAmount, totalReward, totalPay;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    await getUser(userNotifier, user.uid,
        start: widget.dateuser[0], end: widget.dateuser[1]);
    userNotifier.currentUser.forEach((element) {
      allresultdate.add(element.date);
    });
    print("defalt == $allresultdate");
    // allresultdate.toSet().toList();
    List allresultdateNEW = 
  allresultdate.map((f) => f.toString()).toSet().toList()
  .map((f) => json.decode(f) as List<dynamic>).toList();
    print("set  ==  $allresultdateNEW");
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Color(0xFFF3FFFE),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "รายงานการซื้อสลาก",
            style: TextStyle(color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Color(0xFF25D4C2),
          elevation: 0,
        ),
        body: ListView.builder(
            itemCount: allresultdate.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 20,
                  color: Colors.amber,
                ),
              );
            }));
  }
}
