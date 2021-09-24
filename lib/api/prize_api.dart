import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/notifier/prize_notifier.dart';

getPrize(PrizeNotifier prizeNotifier) async {
  Map<String, PrizeData> _prizeList = {};
  List<PrizeData> _listDate = [];

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('lottery')
      .orderBy('date', descending: true)
      .get();

  List<String> _id = [];
  List<DocumentSnapshot> documents;
  documents = snapshot.docs;
  documents.forEach((v) {
    PrizeData prizeData = PrizeData.fromJson(v.data());
    _prizeList[v.id] = prizeData;
    _listDate.add(prizeData);
  });

  prizeNotifier.prizeList = _prizeList;
  prizeNotifier.id = _id;
  prizeNotifier.selectedPrize = prizeNotifier.prizeList.values.first;
  return _listDate;
}
