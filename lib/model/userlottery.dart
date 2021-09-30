 
import 'package:cloud_firestore/cloud_firestore.dart';


Future deleteUserLottery(String documentId ) async {
  
  
  await FirebaseFirestore.instance
      .collection('userlottery')
      .doc(documentId)
      .delete();
}
// Future addUserLottery() async{

// }