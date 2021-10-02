import 'package:flutter/material.dart';
import 'package:lotto/model/checkNumber.dart';
import 'package:lotto/widgets/checkedDialog.dart';


class ShowResultChecked extends StatelessWidget {
  final List<CheckResult> allResult;
  final int length;

  ShowResultChecked({key, this.allResult, this.length}) : super(key: key);
  GlobalKey _captureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _captureKey,
      child: Container(
        child: PageView.builder(
          
            itemCount: length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (contex, int index) {
              return showPrizeReward(allResult[index], context, _captureKey);
            }),
      ),
    );
  }

  Container showPrizeReward(CheckResult document, BuildContext context, _key) {
    return Container(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: [
                shareAndClose(
                    displayData(document.usernumber, document.name,
                        document.date, document.status, document.reword,15.3, Colors.amber),
                    context,
                    _key,document.status)
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
      )
    ]));
  }
}
