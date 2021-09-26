import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUser(UserNotifier userNotifier, dynamic userId,
    {String start, String end}) async {
  QuerySnapshot snapshot;
  if (start == null || end == null) {
    snapshot = await FirebaseFirestore.instance
        .collection("userlottery")
        .where('userid', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
  } else {
    snapshot = await FirebaseFirestore.instance
        .collection("userlottery")
        .where('userid', isEqualTo: userId)
        .where("date", isLessThanOrEqualTo: end)
        .where("date", isGreaterThanOrEqualTo: start)
        .orderBy('date', descending: true)
        .get();
  }

  List<UserData> _currentUser = [];
  List<String> _docID = [];

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;

  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _currentUser.add(userData);
    _docID.add(data.id);
  });

  userNotifier.currentUser = _currentUser;
  userNotifier.docID = _docID;
  print("api = ${userNotifier.docID}");
}
