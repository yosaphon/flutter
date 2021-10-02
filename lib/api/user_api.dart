import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notification.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUser(UserNotifier userNotifier, dynamic userId,
    {UserSumaryNotifier userSumaryNotifier}) async {
  QuerySnapshot snapshot;

  Map<String, UserData> _keyCurrentUser = {};

  snapshot = await FirebaseFirestore.instance
      .collection("userlottery")
      .where('userid', isEqualTo: userId)
      .orderBy('date', descending: true)
      .orderBy("number")
      .get();
  List<UserData> _currentUser = [];
  List<String> _docID = [];

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;

  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _currentUser.add(userData);
    _keyCurrentUser[data.id] = userData;
    _docID.add(data.id);
  });
  String _token = await getToken();

  userNotifier.currentUser = _currentUser;
  userNotifier.docID = _docID;
  userNotifier.keyCurrentUser = _keyCurrentUser;
  userNotifier.token = _token;

  if (userSumaryNotifier != null) userSumaryNotifier.userSumary = _currentUser;
}
