 
import 'package:cloud_firestore/cloud_firestore.dart';

class Userlottery {
  String userid;
  String number;
  String amount;
  String lotteryprice;
  String username;

  Userlottery({this.userid, this.number, this.amount,this.lotteryprice, this.username});
}

Future deleteUserLottery(String documentId) async {
  
  await FirebaseFirestore.instance
      .collection('userlottery')
      .doc(documentId)
      .delete();
}