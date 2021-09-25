import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      extendBodyBehindAppBar: false,
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
            //future: getPrize(prizeNotifier),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (prizeNotifier.prizeList.isEmpty) {
            return CircularProgressIndicator();
          } else {
            //print(snapshot.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownDate(prizeNotifier.prizeList.values),
                Expanded(
                  child: ListView(
                    children: <Widget>[ 
                      frameWidget(
                        PrizeBox(
                            //รางวัลที่ 1
                            "รางวัลที่ 1",
                            prizeNotifier.selectedPrize.data['first'].price,
                            prizeNotifier.selectedPrize.data['first'].number,
                            35,
                            2.2,
                            1),
                      ),
                      frameWidget(
                        Row(
                          //รางวัลเลขหน้า 3, เลขท้าย 3
                          children: <Widget>[
                            Expanded(
                              child: PrizeBox(
                                  "เลขหน้า 3 ตัว",
                                  prizeNotifier.selectedPrize.data['last3f'].price,
                                  prizeNotifier.selectedPrize.data['last3f'].number,
                                  22,
                                  4,
                                  2),
                            ),
                            Expanded(
                              child: PrizeBox(
                                  "เลขท้าย 3 ตัว",
                                  prizeNotifier.selectedPrize.data['last3b'].price,
                                  prizeNotifier.selectedPrize.data['last3b'].number,
                                  22,
                                  4,
                                  2),
                            ),
                          ],
                        ),
                      ),
                      frameWidget(
                        PrizeBox(
                            "เลขท้าย 2 ตัว",
                            prizeNotifier.selectedPrize.data['last2'].price,
                            prizeNotifier.selectedPrize.data['last2'].number,
                            30,
                            2,
                            1),
                      ),
                      frameWidget(
                        PrizeBox(
                            "รางวัลใกล้เคียง",
                            prizeNotifier.selectedPrize.data['near1'].price,
                            prizeNotifier.selectedPrize.data['near1'].number,
                            24,
                            3,
                            2),
                      ),
                      frameWidget(
                        PrizeBox(
                            "รางวัลที่ 2",
                            prizeNotifier.selectedPrize.data['second'].price,
                            prizeNotifier.selectedPrize.data['second'].number,
                            18,
                            3,
                            3),
                      ),
                      frameWidget(
                        PrizeBox(
                            "รางวัลที่ 3",
                            prizeNotifier.selectedPrize.data['third'].price,
                            prizeNotifier.selectedPrize.data['third'].number,
                            12,
                            4,
                            5),
                      ),
                      frameWidget(
                        PrizeBox(
                            "รางวัลที่ 4",
                            prizeNotifier.selectedPrize.data['fourth'].price,
                            prizeNotifier.selectedPrize.data['fourth'].number,
                            12,
                            4,
                            5),
                      ),
                      frameWidget(
                        PrizeBox(
                            "รางวัลที่ 5",
                            prizeNotifier.selectedPrize.data['fifth'].price,
                            prizeNotifier.selectedPrize.data['fifth'].number,
                            12,
                            4,
                            5),
                      ),
                      SizedBox(height: 100,)
                    
                    ],
                  ),
                ),
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

  Widget frameWidget(Widget dataWidget) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: dataWidget),
    );
  }
}
