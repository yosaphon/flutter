import 'package:flutter/material.dart';

class PrizeBox extends StatelessWidget {
  String name; //ชื่อรางวัล
  String reward; //รางวัล
  List<dynamic> number; //ตัวเลข
  int itemInRow;

  PrizeBox(this.name, this.reward, this.number, this.itemInRow);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(name),
          Text('รางวัลละ $reward บาท'),
          Center(
            child: GridView.count(
              childAspectRatio: 2 / (2 / 4),
              crossAxisCount: itemInRow,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: number.map<Widget>((a) {
                return Text(a ,textAlign: TextAlign.center,); 
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}