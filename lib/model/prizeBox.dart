import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrizeBox extends StatelessWidget {
  final String name; //ชื่อรางวัล
  final String reward; //รางวัล
  final List<dynamic> number; //ตัวเลข
  final int itemInRow;
  final double size;
  final double hig;

  PrizeBox(
      this.name, this.reward, this.number, this.itemInRow, this.size, this.hig);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 18)),
          Text('รางวัลละ ${NumberFormat("#,###").format(int.parse(reward))}  บาท',
              style: TextStyle(fontSize: 12)),
          SizedBox(
            height: 10,
          ),
          Center(
            child: GridView.count(
              childAspectRatio: 2 / (1.5 / hig),
              crossAxisCount: itemInRow,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: number.map<Widget>((a) {
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
