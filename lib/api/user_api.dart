import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/SumaryData.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/notifier/sumary_notifier.dart';
import 'package:lotto/notifier/user_notifier.dart';

getUser(UserNotifier userNotifier, dynamic userId,
    {SumaryNotifier sumaryNotifier}) async {
  double sumReward = 0, sumPay = 0;

  int sumAmount = 0;
  QuerySnapshot snapshot;

  snapshot = await FirebaseFirestore.instance
      .collection("userlottery")
      .where('userid', isEqualTo: userId)
      .orderBy('date', descending: true)
      .get();

  List<UserData> _currentUser = [];
  List<String> _docID = [];
  List<SumaryData> _listSumaryData = [];

  List<DocumentSnapshot> documents;
  documents = snapshot.docs;

  documents.forEach((data) {
    UserData userData = UserData.fromJson(data.data());
    _currentUser.add(userData);
    _docID.add(data.id);

    sumReward += userData.reward == null ? 0.00 : double.parse(userData.reward);
    sumPay += userData.lotteryprice == null
        ? 0.00
        : double.parse(userData.lotteryprice);

    sumAmount = int.parse(userData.amount);

    SumaryData sumaryData = SumaryData(
        date: userData.date,
        sumReward: sumReward,
        sumPay: sumPay,
        amount: sumAmount,
        checked: userData.state);

    _listSumaryData.add(sumaryData);
  });

  userNotifier.currentUser = _currentUser;
  userNotifier.docID = _docID;

  if (sumaryNotifier != null) {
    sumaryNotifier.listSumary = _listSumaryData;
  }
}
