// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class DispalyPredictor extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         extendBodyBehindAppBar: false,
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             "ใบ้รางวัล",
//             style: TextStyle(color: Colors.black),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//           ),
//           backgroundColor: Colors.black.withOpacity(0.1),
//           elevation: 0,
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: 20,),
//               Container(
//                 height: 150.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   color: Colors.blue[100],
//                 ),
//                 child: Column(
//                   children: [

//                   ],
//                 ),
//               ),
//               SizedBox(height: 20,),
//               Container(
                
//                 height: 150.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   color: Colors.blue[100],
//                 ),
//                 child: Column(
//                   children: [

//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lotto/model/preditionlottery.dart';
import 'package:lotto/model/prizeBox.dart';
import 'package:lotto/screen/showCheckImage.dart';

class DispalyPredictor extends StatefulWidget {
  @override
  _DispalyPredictorState createState() => _DispalyPredictorState();
}

class _DispalyPredictorState extends State<DispalyPredictor> {
  //สร้าง List ไว้เก็บ Lottery
  var snapshot;
  List<DocumentSnapshot> documents;
  Map<String, String> date = {};
  String dateValue;

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
      documents.forEach((data) =>
          date[data.id] = data['drawdate']); //เก็บชื่อวัน และ เลขวันเป็น map
      dateValue = date.values.last; //เรียกค่าอันสุดท้าย
    });
  }

  getNumberByNameDate() {
    return date.keys.firstWhere((k) => date[k] == dateValue, //หา Keys โดยใช้ value
        orElse: () => null);
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
                .doc(getNumberByNameDate())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || !snapshot.data.exists) {
                return CircularProgressIndicator();
              } else {
                return ListView(
                  children: <Widget>[
                    lottoerypredition(
                        //ส่งค่า รางวัลไปคำนวณ ที่lottoerypredition
                        snapshot.data['result'][0]['number'],
                        snapshot.data['result'][1]['number'],
                        snapshot.data['result'][2]['number'],
                        snapshot.data['result'][3]['number'],
                        ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

