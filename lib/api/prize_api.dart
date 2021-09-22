import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/notifier/prize_notifier.dart';

getPrize(PrizeNotifier prizeNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('lottery').orderBy('date',descending: true).get();

  Map<String, PrizeData> _prizeList = {};
  List<String> _id = [];
  List<DocumentSnapshot> documents;
  documents = snapshot.docs;
  documents.forEach((data) {
    PrizeData prizeData = PrizeData.fromJson(data.data());
    _prizeList[data.id] = prizeData;
    // _prizeList.add(prizeData);
    // _id.add(data.id);
  });

  prizeNotifier.prizeList = _prizeList;
  prizeNotifier.id = _id;
}
