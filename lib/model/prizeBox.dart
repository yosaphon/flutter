
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrizeBox extends StatelessWidget {
  String name; //ชื่อรางวัล
  int reward; //รางวัล
  dynamic number; //ตัวเลข 1 ตัว
  List<dynamic> mNum = []; //ตัวเลขหลายตัว
  int itemInRow; //จำนวนแ
  double size; //ขนาดตัวอักษร
  double hig; // ขนาดช่อง

  PrizeBox(this.name, this.reward, this.number, this.itemInRow, this.size,
      this.hig) {
    if (name == 'รางวัลที่ 1' || name == 'เลขท้าย 2 ตัว') {
      mNum.add(number);
    } else {
      number.forEach((e) => mNum.add(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 18)),
          Text('รางวัลละ ${NumberFormat("#,###").format(reward)} บาท',
              style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          Center(
            child: GridView.count(
              childAspectRatio: 2 / (1.5 / hig),
              crossAxisCount: itemInRow,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: mNum.map<Widget>((a) {
                return Text(
                  a,
                  style: TextStyle(fontSize: size, color: Colors.blue),
                  textAlign: TextAlign.center,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
