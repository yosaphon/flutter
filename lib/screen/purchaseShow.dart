import 'package:flutter/material.dart';
import 'package:lotto/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class ShowPurchaseReport extends StatelessWidget {
  final dateuser; // filter สำหรับหาวันที่
  const ShowPurchaseReport({this.dateuser});

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
      ),body: Center(child: Text("date",),)
    );
  }
}