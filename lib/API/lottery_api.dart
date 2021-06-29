import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lotto/model/lotteryData.dart';
import 'package:lotto/provider/lottery_provider.dart';

getLottery(LotteryNotifier lotteryNotifier) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('lottery').get();

  List<LotteryData> _lotteryList = [];

  snapshot.docs.forEach((document) {
    LotteryData lottery = LotteryData.fromMap(document.data());
        _lotteryList.add(lottery);
  });

  lotteryNotifier.lotteryList = _lotteryList;
}
