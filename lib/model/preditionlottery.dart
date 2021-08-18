import 'package:flutter/material.dart';

class lottoerypredition extends StatelessWidget {
  
  dynamic number1, number2, numberfornt3, numberblack3; //ตัวเลข 1 ตัว
  // List<dynamic> mNum = []; //ตัวเลขหลายตัว
  String a, b, c, d, e, f, g, h;
  String type, R1str, P1str, R2str, P2str, Result;
  int R1, O1, P1, R2, O2, P2;

  lottoerypredition(this.number1, this.number2, this.numberfornt3,
      this.numberblack3, this.type) {
    if (type == "1") {
// a = หลักที่สิบของเลขท้ายสองตัว, b = สามตัวหน้าของครั้งที่ 1 ที่เป็นหลักร้อย
//c = สามตัวท้ายครั้งที่ 2 ที่เป็นหลักร้อย,d = สามตัวท้ายครั้งที่ 2 หลักที่สิบ, e = หลักแสนของรางวัลที่ 1,
//f = หลักหมื่นของรางวัลที่ 1, g = หลักหน่วยของรางวัลที่ 1, h = สามตัวหน้าครั้งที่ 2 หลักร้อย
      a = number2.toString().substring(0, 1);
      b = numberfornt3.toString().substring(1, 2);
      c = numberblack3.toString().substring(6, 7);
      d = numberblack3.toString().substring(7, 8);
      e = number1.toString().substring(0, 1);
      f = number1.toString().substring(1, 2);
      g = number1.toString().substring(5, 6);
      h = numberfornt3.toString().substring(6, 7);
      R1 = int.parse(a) + int.parse(b) + int.parse(c) + int.parse(d);
      R1str = R1.toString();
      R1str = R1str.substring(R1str.length - 1, R1str.length);
      O1 = int.parse(R1str);
      P1 = O1 + 5;
      P1str = P1.toString();
      P1str = P1.toString().substring(P1str.length - 1, P1str.length);

      R2 = int.parse(b) +
          int.parse(c) +
          int.parse(e) +
          int.parse(f) +
          int.parse(g) +
          int.parse(h);
      R2str = R2.toString();
      R2str = R2str.substring(R2str.length - 1, R2str.length);
      O2 = int.parse(R2str);
      P2 = O2 + 7;
      P2str = P2.toString();
      P2str = P2.toString().substring(P2str.length - 1, P2str.length);
      Result = O1.toString() +
          O2.toString() +
          "  " +
          O1.toString() +
          P2str +
          "  " +
          P1str +
          O2.toString() +
          "  " +
          P1str +
          P2str;
    } else if (type == "2") {
// a = หลักร้อยของรางวัลที่ 1,b = หลักสิบของเลขท้าย 2 ตัว,c = หลักหน่วยของเลขท้าย 2 ตัว
// d = หลักแสนของรางวัลที่ 1,e = หลักหมื่นของรางวัลที่ 1,f = หลักพันของรางวัลที่ 1
      a = number1.toString().substring(3, 4);
      b = number2.toString().substring(0, 1);
      c = number2.toString().substring(1, 2);
      d = number1.toString().substring(0, 1);
      e = number1.toString().substring(1, 2);
      f = number1.toString().substring(2, 3);
      R1 = int.parse(a) + int.parse(b) + (int.parse(c) * 4) + 4;
      R1str = R1.toString();
      R1str = R1str.substring(R1str.length - 1, R1str.length);

      R2 = int.parse(b) + int.parse(e) + (int.parse(f) * 2) + int.parse(b) + 2;
      R2str = R2.toString();
      R2str = R2str.substring(R2str.length - 1, R2str.length);
      Result = R1str + R2str + "     " + R2str + R1str;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        Text("สูตรใบ้ " + type, style: TextStyle(fontSize: 16)),
        SizedBox(height: 30,),
                  Text(
                  Result,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
      ],
    );
  }
}
