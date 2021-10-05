import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          PageTransition(
              duration: Duration(milliseconds: 1000),
              reverseDuration: Duration(milliseconds: 1000),
              type: PageTransitionType.fade,
              child: MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3f51b5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/guraLottery.png',
              height: 100,
              width: 100,
            ),
            Text(
              "Lotto Check",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SpinKitWave(
              color: Colors.amber,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
