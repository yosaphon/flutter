import 'package:flutter/material.dart';

class PrizeBox extends StatelessWidget {
  String name; //ชื่อรางวัล
  String reward; //รางวัล
  List<dynamic> number; //ตัวเลข

  PrizeBox(this.name, this.reward, this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(name),
          Text('รางวัลละ $reward บาท'),
          Center(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: number.map<Widget>((a) {
                return Text(a);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
