import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/prizeBox.dart';


class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};
  String dateValue ;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    QuerySnapshot snapAll =
        await FirebaseFirestore.instance.collection('lottery').get();
        setState(() {
          documents = snapAll.docs; //รับทุก docs ใน firebase
          documents.forEach((data) => date[data.id] = data['drawdate']);//เก็บชื่อวัน และ เลขวันเป็น map
          dateValue = date.values.last;//เรียกค่าอันสุดท้าย
        });
    
  }

  @override
  Widget build(BuildContext context) {
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
              stream: FirebaseFirestore.instance
                  .collection('lottery')
                  .doc(date.keys.firstWhere(
                      (k) => date[k] == dateValue, //หา Keys โดยใช้ value
                      orElse: () => null))
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || !snapshot.data.exists) {
                  return CircularProgressIndicator();
                } else {
                  return ListView(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black26, width: 0.5),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(top: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
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
                              });
                            },
                            items: date.values
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textAlign: TextAlign.right,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      PrizeBox(
                          //รางวัลที่ 1
                          snapshot.data['result'][0]['name'],
                          snapshot.data['result'][0]['reword'],
                          snapshot.data['result'][0]['number'],
                          1,
                          35,
                          8),
                      Row(
                        //รางวัลเลขหน้า, เลขท้าย
                        children: <Widget>[
                          Expanded(
                            child: PrizeBox(
                                snapshot.data['result'][1]['name'],
                                snapshot.data['result'][1]['reword'],
                                snapshot.data['result'][1]['number'],
                                2,
                                28,
                                2),
                          ),
                          Expanded(
                            child: PrizeBox(
                                snapshot.data['result'][2]['name'],
                                snapshot.data['result'][2]['reword'],
                                snapshot.data['result'][2]['number'],
                                2,
                                28,
                                2),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      PrizeBox(
                          //รางวัลเลขท้าย 2 ตัว
                          snapshot.data['result'][3]['name'],
                          snapshot.data['result'][3]['reword'],
                          snapshot.data['result'][3]['number'],
                          1,
                          28,
                          9),
                      PrizeBox(
                          //รางวัลใกล้เคียง รางวัลที่ 1
                          snapshot.data['result'][4]['name'],
                          snapshot.data['result'][4]['reword'],
                          snapshot.data['result'][4]['number'],
                          2,
                          22,
                          6),
                      PrizeBox(
                          //รางวัลที่ 2
                          snapshot.data['result'][5]['name'],
                          snapshot.data['result'][5]['reword'],
                          snapshot.data['result'][5]['number'],
                          4,
                          22,
                          3),
                      PrizeBox(
                          //รางวัลที่ 3
                          snapshot.data['result'][6]['name'],
                          snapshot.data['result'][6]['reword'],
                          snapshot.data['result'][6]['number'],
                          5,
                          18,
                          2),
                      SizedBox(
                        height: 10,
                      ),
                      PrizeBox(
                          //รางวัลที่ 4
                          snapshot.data['result'][7]['name'],
                          snapshot.data['result'][7]['reword'],
                          snapshot.data['result'][7]['number'],
                          5,
                          18,
                          2),
                      SizedBox(
                        height: 10,
                      ),
                      PrizeBox(
                          //รางวัลที่ 5
                          snapshot.data['result'][8]['name'],
                          snapshot.data['result'][8]['reword'],
                          snapshot.data['result'][8]['number'],
                          5,
                          18,
                          2),
                          SizedBox(
                            height: 55,
                          )
                    ],
                  );
                }
              }),
        ),
         floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => QRScanPage()),
          // );
        },
        child: Text("ใบตรวจ"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
  }
}
