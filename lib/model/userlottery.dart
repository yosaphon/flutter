 
import 'package:cloud_firestore/cloud_firestore.dart';

class Userlottery {
  String userid;
  String number;
  String amount;
  String lotteryprice;
  String username;
  String imageurl;
  String date;

  Userlottery({this.userid, this.number, this.amount,this.lotteryprice, this.username , this.imageurl ,this.date});
}

Future deleteUserLottery(String documentId) async {
  
  await FirebaseFirestore.instance
      .collection('userlottery')
      .doc(documentId)
      .delete();
}