import 'package:flutter/material.dart';

class PurchaseReport extends StatefulWidget {
  @override
  _PurchaseReportState createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "รายงานผลการซื้อสลาก",
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
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Text("เริ่ม"),
            ),SizedBox(
              height: 100,
              width: 100,
              child: Text("ถึง"),
            )
          ],
        ),
      ),
    );
  }
}
