import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:footer/footer.dart';
import 'package:lotto/main.dart';
import 'package:page_transition/page_transition.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;

  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
              duration: Duration(milliseconds: 500),
              reverseDuration: Duration(milliseconds: 5000),
              type: PageTransitionType.rightToLeft,
              child: MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FFFE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'asset/guraLottery.png',
              height: 90,
              width: 90,
            ),
            SizedBox(height: 10,),
            Text(
              "Lotto Check",
              style: TextStyle(
                fontSize: 18,color: Colors.black87
              ,fontFamily: "Mitr"),
            ),
            Spacer(),
            Footer(backgroundColor: Colors.redAccent[100],
              child: Text("v1.0.0" ,style: TextStyle(fontSize: 10,color: Colors.black87),))
          ],
        ),
      ),
    );
  }
}
