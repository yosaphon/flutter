import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/showCheckImage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};
  String dateValue;
  int i = 0;

  @override
  void initState() {
    PrizeNotifier prizeNotifier =
        Provider.of<PrizeNotifier>(context, listen: false);

    loadData(prizeNotifier);
    super.initState();
  }

  Future loadData(PrizeNotifier prizeNotifier) async {
    await getPrize(prizeNotifier);
    setState(() {
      prizeNotifier.prizeList.forEach((key, value) =>
          date[key] = value.date); //เก็บชื่อวัน และ เลขวันเป็น map
      dateValue = date.values.first; //เรียกค่าอันสุดท้าย});
      prizeNotifier.selectedPrize = prizeNotifier.prizeList[getKeyByValue()];
    });
  }

  getNumberByNameDate() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
  }
  getKeyByValue() {
    return date.keys
        .firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
            orElse: () => null);
  }

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ผลรางวัลฉลากกินแบ่งรัฐบาล",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (prizeNotifier.prizeList.isEmpty) {
            return CircularProgressIndicator();
          } else {
            return ListView(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.topCenter,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 0.5),
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dateValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      elevation: 2,
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dateValue = newValue;
                          prizeNotifier.selectedPrize =
                              prizeNotifier.prizeList[getKeyByValue()];
                          print(getKeyByValue());
                          print(prizeNotifier.prizeList[getKeyByValue()]);
                        });
                      },
                      items: prizeNotifier.prizeList.values
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value.date,
                          child: Text(
                            value.date,
                            textAlign: TextAlign.right,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                PrizeBox(
                    //รางวัลที่ 1
                    "รางวัลที่ 1",
                    prizeNotifier.selectedPrize.data['first'].price,
                    prizeNotifier.selectedPrize.data['first'].number[0].value,
                    1,
                    35,
                    8),
                // Row(
                //   //รางวัลเลขหน้า, เลขท้าย
                //   children: <Widget>[
                //     Expanded(
                //       child: PrizeBox(
                //           snapshot.data['result'][1]['name'],
                //           snapshot.data['result'][1]['reword'],
                //           snapshot.data['result'][1]['number'],
                //           2,
                //           28,
                //           2),
                //     ),
                //     Expanded(
                //       child: PrizeBox(
                //           snapshot.data['result'][2]['name'],
                //           snapshot.data['result'][2]['reword'],
                //           snapshot.data['result'][2]['number'],
                //           2,
                //           28,
                //           2),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // PrizeBox(
                //     //รางวัลเลขท้าย 2 ตัว
                //     snapshot.data['result'][3]['name'],
                //     snapshot.data['result'][3]['reword'],
                //     snapshot.data['result'][3]['number'],
                //     1,
                //     28,
                //     9),
                // PrizeBox(
                //     //รางวัลใกล้เคียง รางวัลที่ 1
                //     snapshot.data['result'][4]['name'],
                //     snapshot.data['result'][4]['reword'],
                //     snapshot.data['result'][4]['number'],
                //     2,
                //     22,
                //     6),
                // PrizeBox(
                //     //รางวัลที่ 2
                //     snapshot.data['result'][5]['name'],
                //     snapshot.data['result'][5]['reword'],
                //     snapshot.data['result'][5]['number'],
                //     4,
                //     22,
                //     3),
                // PrizeBox(
                //     //รางวัลที่ 3
                //     snapshot.data['result'][6]['name'],
                //     snapshot.data['result'][6]['reword'],
                //     snapshot.data['result'][6]['number'],
                //     5,
                //     18,
                //     2),
                // SizedBox(
                //   height: 10,
                // ),
                // PrizeBox(
                //     //รางวัลที่ 4
                //     snapshot.data['result'][7]['name'],
                //     snapshot.data['result'][7]['reword'],
                //     snapshot.data['result'][7]['number'],
                //     5,
                //     18,
                //     2),
                // SizedBox(
                //   height: 10,
                // ),
                // PrizeBox(
                //     //รางวัลที่ 5
                //     snapshot.data['result'][8]['name'],
                //     snapshot.data['result'][8]['reword'],
                //     snapshot.data['result'][8]['number'],
                //     5,
                //     18,
                //     2),
                // SizedBox(
                //   height: 55,
                // )
              ],
            );
          }
        }),
      ),
       floatingActionButton: Column(
        children: [
          Spacer(),
          FloatingActionButton.extended(
            heroTag: "btnyoutube",
            onPressed: () async {
                    // if (await canLaunch(document.youtubeUrl)) {
                    //   await launch(document.youtubeUrl);
                    // }
            },
            icon: FaIcon(FontAwesomeIcons.youtube),
            label: const Text(
              'Youtube',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton.extended(
            heroTag: "btnreadpdf",
            onPressed: () {
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new ShowCheckImage(
                      date: getNumberByNameDate().substring(2, 8),
                    )),
          );
            },
            icon: Icon(Icons.receipt_long),
            label: const Text(
              'ใบตรวจ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.amber,
          ),
          FloatingActionButton.extended(
            heroTag: "btn3",
            tooltip: 'Increment',
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () async {},
            label: Opacity(
              opacity: 0,
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
