// import 'dart:collection';

// import 'package:flutter/cupertino.dart';
// import 'package:lotto/model/userlottery.dart';


// class LotteryNotifier with ChangeNotifier {
//   List<Userlottery> _lotteryList = [];
//   Userlottery _currentLottery;

//   UnmodifiableListView<Userlottery> get lotteryList => UnmodifiableListView(_lotteryList);

//   Userlottery get currentlottery => _currentLottery;

//   set lotteryList(List<Userlottery> lotteryList) {
//     _lotteryList = lotteryList;
//     notifyListeners();
//   }

//   set currentLottery(Userlottery lottery) {
//     _currentLottery = lottery;
//     notifyListeners();
//   }

//   addLottery(Userlottery lottery) {
//     _lotteryList.insert(0, lottery);
//     notifyListeners();
//   }

//   deleteLottery(Userlottery lottery) {
//     _lotteryList.removeWhere((_lottery) => _lottery.userid == lottery.userid);
//     notifyListeners();
//   }
// }