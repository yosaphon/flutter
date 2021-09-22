import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/prize_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUser(UserNotifier userNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('userlottery').get();

  List<UserData> _userList = [];

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;
  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _userList.add(userData);
    // _id.add(data.id);
  });

  userNotifier.userList = _userList;
}
