import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckDialog {
  final String date;
  final String userNum;
  String name= "ไม่ถูกรางวัล", number="", reward="";

  CheckDialog(this.date, this.userNum);

  Future<Null> alertChecking(BuildContext context) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('lottery').doc(date).get();

    snapshot['prizes'].forEach((index) {
      index['number'].forEach((a) {
        if (a == userNum) {
          name = index['name'];
          number = a;
          reward = index['reward'];
        }
      });
    });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                title: Text(userNum),
                subtitle: Text('$name มูลค่า $reward บาท'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            ));
  }
}
