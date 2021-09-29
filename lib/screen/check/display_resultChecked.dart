import 'package:flutter/material.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/widgets/checkedDialog.dart';
import 'package:provider/provider.dart';

class ShowResultChecked extends StatelessWidget {
  final List<CheckResult> allResult;
  final int length;

  ShowResultChecked({key, this.allResult,this.length}) : super(key: key);
  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blueAccent,
                    Colors.pink,
                  ],
                ),
              ),
              child: PageView.builder(
                  itemCount: length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (contex, int index) {
                    return showPrizeReward(allResult[index], context);
                  })),
        ));
  }

  Container showPrizeReward(CheckResult document, BuildContext context) {
    return Container(
        child: Column(
      children: [Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Column(
                children: [
                  shareAndClose(
                      displayData(document.usernumber, document.name, document.date, document.status, 15.3,
                          Colors.amber),
                      context)
                ],
              )),
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
        )]
      
    ));
  }
}
