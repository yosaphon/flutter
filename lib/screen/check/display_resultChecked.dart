import 'package:flutter/material.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/widgets/checkedDialog.dart';

class ShowResultChecked extends StatelessWidget {
  final Map<String, List<CheckResult>> allResult;
  
  ShowResultChecked({key, this.allResult}) : super(key: key);
  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: ListView(
        children: allResult.values.map((document) {
          return Container(
              child: Column(
            children: document.map((e) {
              return Container(
    margin: EdgeInsets.only(left: 20,right: 20),
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: [shareAndClose(displayData(e.usernumber,e.name,e.date,e.status,15.3,Colors.amber),context)    ],
      )
    ),
    decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 9,
                  offset: Offset(0, 1), // changes position of shadow
                ),
        ],
      ),
  );
            }).toList(),
          ));
        }).toList(),
      ),
    )
  );}
}
