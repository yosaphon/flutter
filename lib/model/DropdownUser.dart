import 'package:flutter/material.dart';

import 'package:lotto/notifier/prize_notifier.dart';
import 'package:provider/provider.dart';

class DropdownUserDate extends StatefulWidget {
  final prizeData;
  DropdownUserDate({this.prizeData});
  @override
  _DropdownUserDateState createState() => _DropdownUserDateState(this.prizeData);
}

class _DropdownUserDateState extends State<DropdownUserDate> {
  final prizeData;
  _DropdownUserDateState(this.prizeData);
  Map<String, String> date = {};
  String dateValue;

  @override
  void initState() {
    if (prizeData != null ) {
      dateValue = prizeData.first.date;
    }
    super.initState();
  }

  getKeyByValue(String value) {
    List<String> w = value.split('-');
    return w[0] + w[1] + w[2];
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
        dateValue = prizeNotifier.selectedPrize.date;
    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dateValue,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.amber,
          ),
          iconSize: 30,
          elevation: 2,
          style: TextStyle(color: Colors.indigo, fontSize: 22),
          underline: Container(
            height: 2,
            color: Colors.red,
          ),
          selectedItemBuilder: (BuildContext context) {
            return prizeNotifier.prizeList.values.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value.date,
                child: Text(
                  numToWord(value.date),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList();
          },
          onChanged: (String newValue) {
            setState(() {
              dateValue = newValue;
              prizeNotifier.selectedPrize =
                  prizeNotifier.prizeList[getKeyByValue(dateValue)];
              print(getKeyByValue(dateValue));
              print(prizeNotifier.prizeList[getKeyByValue(dateValue)]);
            });
          },
          items: prizeNotifier.prizeList.values.map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: value.date,
              child: Text(
                numToWord(value.date),
                textAlign: TextAlign.right,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

String numToWord(String n) {
  List<String> month = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม"
  ];
  List<String> w = n.split('-');

  return int.parse(w[2]).toString() +
      " " +
      month[int.parse(w[1]) - 1] +
      " " +
      (int.parse(w[0]) + 543).toString();
}
