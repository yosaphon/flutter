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
  _ShowPurchaseReportState(this.dateuser);
  String totalProfit, totalWon, totalLose, totalAmount,totalReward,totalPay;
  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    getUser(userNotifier, user.uid,
        start: widget.dateuser[0], end: widget.dateuser[1]);

    userNotifier.currentUser.forEach((element) {});

    super.initState();
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
        body: Center(
          child: Text(""),
        ));
  }
}
