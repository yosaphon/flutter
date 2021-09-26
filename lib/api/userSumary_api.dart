import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUserSumary(UserSumaryNotifier userSumaryNotifier, dynamic userId,
    { String start, String end}) async {
  QuerySnapshot snapshot;
 
    snapshot = await FirebaseFirestore.instance
        .collection("userlottery")
        .where('userid', isEqualTo: userId)
        .where("date", isLessThanOrEqualTo: end)
        .where("date", isGreaterThanOrEqualTo: start)
        .orderBy('date', descending: true)
        .get();
  

  List<UserData> _userSumary = [];
  // List<String> _docID = [];

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;

  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _userSumary.add(userData);
    //_docID.add(data.id);
  });

  userSumaryNotifier.userSumary = _userSumary;
  //userNotifier.docID = _docID;
  //print("api = ${userNotifier.docID}");
}
