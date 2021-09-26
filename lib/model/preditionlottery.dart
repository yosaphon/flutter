import 'package:flutter/material.dart';

class lottoerypredition extends StatelessWidget {
  
  dynamic number1, number2, numberfornt3f,numberfornt3s, numberblack3f, numberblack3s; //ตัวเลข 1 ตัว
  // List<dynamic> mNum = []; //ตัวเลขหลายตัว
  String a, b, c, d, e, f, g, h;
  String type, r1str, p1str, r2str, p2str, result;
  int r1, o1, p1, r2, o2, p2;

  lottoerypredition(this.number1, this.number2, this.numberfornt3f, this.numberfornt3s,
      this.numberblack3f,
      this.numberblack3s, this.type) {
    if (type == "1") {
// a = หลักที่สิบของเลขท้ายสองตัว, b = สามตัวหน้าของครั้งที่ 1 ที่เป็นหลักร้อย
//c = สามตัวท้ายครั้งที่ 2 ที่เป็นหลักร้อย,d = สามตัวท้ายครั้งที่ 2 หลักที่สิบ, e = หลักแสนของรางวัลที่ 1,
//f = หลักหมื่นของรางวัลที่ 1, g = หลักหน่วยของรางวัลที่ 1, h = สามตัวหน้าครั้งที่ 2 หลักร้อย
      a = number2.toString().substring(0, 1);

      b = numberfornt3f.toString().substring(0, 1);

      h = numberfornt3s.toString().substring(0, 1);

      c = numberblack3f.toString().substring(0, 1);
      d = numberblack3s.toString().substring(1, 2);

      e = number1.toString().substring(0, 1);
      f = number1.toString().substring(1, 2);
      g = number1.toString().substring(5, 6);
      
      r1 = int.parse(a) + int.parse(b) + int.parse(c) + int.parse(d);
      r1str = r1.toString();
      r1str = r1str.substring(r1str.length - 1, r1str.length);
      o1 = int.parse(r1str);
      p1 = o1 + 5;
      p1str = p1.toString();
      p1str = p1.toString().substring(p1str.length - 1, p1str.length);

      r2 = int.parse(b) +
          int.parse(c) +
          int.parse(e) +
          int.parse(f) +
          int.parse(g) +
          int.parse(h);
      r2str = r2.toString();
      r2str = r2str.substring(r2str.length - 1, r2str.length);
      o2 = int.parse(r2str);
      p2 = o2 + 7;
      p2str = p2.toString();
      p2str = p2.toString().substring(p2str.length - 1, p2str.length);
      result = o1.toString() +
          o2.toString() +
          "  " +
          o1.toString() +
          p2str +
          '\n\n'+
          p1str +
          o2.toString() +
          "  " +
          p1str +
          p2str;
    } else if (type == "2") {
// a = หลักร้อยของรางวัลที่ 1,b = หลักสิบของเลขท้าย 2 ตัว,c = หลักหน่วยของเลขท้าย 2 ตัว
// d = หลักแสนของรางวัลที่ 1,e = หลักหมื่นของรางวัลที่ 1,f = หลักพันของรางวัลที่ 1
      a = number1.toString().substring(3, 4);
      b = number2.toString().substring(0, 1);
      c = number2.toString().substring(1, 2);
      d = number1.toString().substring(0, 1);
      e = number1.toString().substring(1, 2);
      f = number1.toString().substring(2, 3);
      r1 = int.parse(a) + int.parse(b) + (int.parse(c) * 4) + 4;
      r1str = r1.toString();
      r1str = r1str.substring(r1str.length - 1, r1str.length);

      r2 = int.parse(b) + int.parse(e) + (int.parse(f) * 2) + int.parse(b) + 2;
      r2str = r2.toString();
      r2str = r2str.substring(r2str.length - 1, r2str.length);
      result = r1str + r2str + "     " + r2str + r1str;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
        ),
        // Text("สูตรใบ้ " + type, style: TextStyle(fontSize: 16)),
        SizedBox(height: 30,),
                  Text(
                  result,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
      ],
    );
  }
}
