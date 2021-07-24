import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CheckedDialog extends StatelessWidget {
  final Map<int, Map<String, dynamic>> data;

  Color boxColor ;
  List<Widget> dialogList = [];

  CheckedDialog(this.data) {
    data.forEach((key, value) {
      List<Widget> listData = wonOrNot(value);
      dialogList.add(Container(
        width: 350,
        decoration: BoxDecoration(
            color: boxColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: listData,
          ),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _bulidChild(context));
  }

  _bulidChild(BuildContext context) => CarouselSlider(
      options: CarouselOptions(
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlay: false),
      items: dialogList);

  List<Widget> wonOrNot(Map<String, dynamic> result) {
    List<Widget> data = [];
    if (result['status'] == "true") {
      data
        ..add(Text(result['usernumber'],
            style: TextStyle(fontSize: 20, color: Colors.white)))
        ..add(Text(
          "คุณถูก!!",
          style: TextStyle(fontSize: 20),
        ))
        ..add(Text(result['name'],
            style: TextStyle(fontSize: 30, color: Colors.red)))
        ..add(Text("งวดที่ ${result['date']}"));
      boxColor = Colors.blueAccent;
    } else {
      data
        ..add(Text(
          result['usernumber'],
          style: TextStyle(fontSize: 20, color: Colors.blueAccent),
        ))
        ..add(Text(
          "คุณไม่ถูกรางวัล",
          style: TextStyle(fontSize: 25),
        ))
        ..add(Text("งวดที่ ${result['date']}"));
      boxColor = Colors.white;
    }
    return data;
  }
}
