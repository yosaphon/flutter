import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/PrizeData.dart';
import 'package:lotto/notifier/prize_notifier.dart';

getPrize(PrizeNotifier prizeNotifier) async {
  Map<String, PrizeData> _prizeList = {};
  List<PrizeData> _listDate = [];
  List<String> _listOutDate = [];

  QuerySnapshot snapshotPrize = await FirebaseFirestore.instance
      .collection('lottery')
      .orderBy('date', descending: true)
      .get();

  List<String> _id = [];
  List<DocumentSnapshot> documents;
  documents = snapshotPrize.docs;
  documents.forEach((v) {
    PrizeData prizeData = PrizeData.fromJson(v.data());
    _prizeList[v.id] = prizeData;
    _listDate.add(prizeData);
  });

  prizeNotifier.prizeList = _prizeList;
  prizeNotifier.id = _id;

  if (prizeNotifier.selectedPrize == null) {
    prizeNotifier.selectedPrize = prizeNotifier.prizeList.values.first;
  }
//ดึงวันที่ออก
  QuerySnapshot snapshotOutDate =
      await FirebaseFirestore.instance.collection('OutDate').get();
  documents = snapshotOutDate.docs;
  for (var i = 0; i <= prizeNotifier.prizeList.values.length; i++) {
    _listOutDate.add(documents[i].get("date"));
  }
  documents = snapshotOutDate.docs;
  prizeNotifier.listOutDate = _listOutDate;
}
