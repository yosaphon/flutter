import 'package:flutter/material.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:provider/provider.dart';

class DropdownDate extends StatefulWidget {
  final List<PrizeData> prizeData;
  DropdownDate(this.prizeData);
  @override
  _DropdownDateState createState() => _DropdownDateState(this.prizeData);
}

class _DropdownDateState extends State<DropdownDate> {
  final List<PrizeData> prizeData;
  _DropdownDateState(this.prizeData);
  Map<String, String> date = {};
  String dateValue;

  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    //print("prizedata = $prizeNotifier");
    loadData(prizeNotifier);
    super.initState();
  }

  Future loadData(PrizeNotifier prizeNotifier) async {
    // prizeData.forEach((value) =>
    //     date[key] = value.date); //เก็บชื่อวัน และ เลขวันเป็น map
    dateValue = prizeData.first.date; //เรียกค่าอันสุดท้าย});

  }

  getKeyByValue(String value) {
    List<String> w = value.split('-');
    return w[0]+w[1]+w[2];
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

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);
    return Container(
      alignment: AlignmentDirectional.topCenter,
      decoration: BoxDecoration(
          color: Color(0xFF25D4C2),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: dateValue,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 30,
          elevation: 2,
          style: TextStyle(color: Colors.black, fontSize: 22),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              dateValue = newValue;
              prizeNotifier.selectedPrize =
                  prizeNotifier.prizeList[getKeyByValue(dateValue)];
              print(getKeyByValue(dateValue));
              print(prizeNotifier.prizeList[getKeyByValue(dateValue)]);
            });
          },
          items: prizeData
              .map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: value.date,
              child: Text(
                numToWord(value.date),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
