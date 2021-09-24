import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lotto/api/prize_api.dart';
import 'package:lotto/model/dropdownDate.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/screen/showCheckImage.dart';
import 'package:provider/provider.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};

  @override
  Widget build(BuildContext context) {
    PrizeNotifier prizeNotifier = Provider.of<PrizeNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFF3FFFE),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ผลรางวัลฉลากกินแบ่งรัฐบาล",
          style: TextStyle(color: Colors.black),
        ),
        shape: RoundedRectangleBorder(),
        // backgroundColor: Colors.transparent,
        backgroundColor: Color(0xFF25D4C2),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
            future: getPrize(prizeNotifier),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return ListView(
                  children: <Widget>[
                    DropdownDate(snapshot.data),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 5),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: PrizeBox(
                            //รางวัลที่ 1
                            "รางวัลที่ 1",
                            prizeNotifier.selectedPrize.data['first'].price,
                            prizeNotifier
                                .selectedPrize.data['first'].number[0].value,
                            1,
                            35,
                            8),
                      ),
                    ),
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
              } else {
                print(snapshot.data);
                return CircularProgressIndicator();
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
                          date: prizeNotifier.selectedPrize.date,
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
