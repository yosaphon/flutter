import 'package:flutter/material.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/screen/check/display_resultChecked.dart';

class ShowResultCheck extends StatelessWidget {
  final List<CheckResult> allResult;
  final int length;

  ShowResultCheck({key, this.allResult, this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ผลการตรวจรางวัล",
          style: TextStyle(color: Colors.black87),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(child: ShowResultChecked(allResult: allResult,length: length,))),
      ),
    );
  }
}
