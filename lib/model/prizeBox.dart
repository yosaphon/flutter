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
  double hig, higth; // ขนาดช่อง สูง
  List<String> _listNumber = [];
  int count ;

  PrizeBox(this.name, this.reward, this.roundNumber, this.size, this.higth,
      this.count) {
    sReward = reward.split('.');
    roundNumber.forEach((e) {
      _listNumber.add(e.value);
    });
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
              childAspectRatio: 2 / (((higth * higth) / 10) / 1.5),
              crossAxisCount: count,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _listNumber.map<Widget>((n) {
                return Text(
                  n,
                  style: TextStyle(fontSize: size, color: Colors.indigo),
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
