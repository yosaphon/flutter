import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PrizeBox extends StatelessWidget {
  String name; //ชื่อรางวัล
  String reward; //รางวัล
  List<dynamic> roundNumber; //ตัวเลข 1 ตัว
  List<String> mNum = []; //ตัวเลขหลายตัว
  List<String> sReward = []; //รางวัล
  double size; //ขนาดตัวอักษร
  double hig,higth; // ขนาดช่อง สูง
  List<String> _listNumber = [];

  PrizeBox(this.name, this.reward, this.roundNumber, this.size,
      this.higth,this.hig) {
    sReward = reward.split('.');
    roundNumber.forEach((e) {
      _listNumber.add(e.value);
    });

    // if (name == 'รางวัลที่ 1' || name == 'เลขท้าย 2 ตัว') {
    //   mNum.add(number);
    // } else {
    //   number.forEach((e) => mNum.add(e));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 18)),
          Text(
              'รางวัลละ ${NumberFormat("#,###").format(int.parse(sReward[0]))} บาท',
              style: TextStyle(fontSize: 12)),
          SizedBox(
            height: 10,
          ),
          Center(
            child: GridView.count(
              childAspectRatio: 2 / (((higth*higth)/10) / hig),
              crossAxisCount: _listNumber.length,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _listNumber.map<Widget>((n) {
                return Text(
                  n,
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
