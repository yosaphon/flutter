import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:lotto/model/lotteryData.dart';

class LotteryNotifier with ChangeNotifier {
  List<LotteryData> _lotteryList = [];
  LotteryData _currentLottery;

  UnmodifiableListView<LotteryData> get lotteryList => UnmodifiableListView(_lotteryList);

  LotteryData get currentLottery => _currentLottery;

  set lotteryList(List<LotteryData> lotteryList) {
    _lotteryList = lotteryList;
    notifyListeners();
  }

  set currentLottery(LotteryData lottery) {
    _currentLottery = lottery;
    notifyListeners();
  }
}