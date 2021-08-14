import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class lottoerypredition extends StatelessWidget {
  dynamic number1, number2, numberfornt3, numberblack3; //ตัวเลข 1 ตัว
  List<dynamic> mNum = []; //ตัวเลขหลายตัว

  lottoerypredition(
      this.number1, this.number2, this.numberfornt3, this.numberblack3) {
        
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 150.0,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: Colors.blue[100],
          ),
          child: Column(
            children: [
              Text("สูตรใบ้ สองตัว", style: TextStyle(fontSize: 16)),
              Container(
                height: 120.0,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 150.0,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: Colors.blue[100],
          ),
          child: Column(
            children: [
              Text("สูตรใบ้ แบบ 4 คู่ ", style: TextStyle(fontSize: 16)),
              Container(
                height: 120.0,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
