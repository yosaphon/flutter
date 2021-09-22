import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUser(UserNotifier userNotifier, dynamic userId) async {
  // QuerySnapshot snapshot =
  //     await FirebaseFirestore.instance.collection('userlottery').get();
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("userlottery")
      .where('userid', isEqualTo: userId)
      .get();

  dynamic _currentUser;

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;
  
  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _currentUser = userData;

    // _id.add(data.id);
  });

  userNotifier.currentUser = _currentUser;
}
