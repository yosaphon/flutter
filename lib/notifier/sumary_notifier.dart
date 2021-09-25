import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/SumaryData.dart';


class SumaryNotifier with ChangeNotifier {
  List<SumaryData> _listSumary=[];



  UnmodifiableListView<SumaryData> get listSumary =>
      UnmodifiableListView(_listSumary);



  set currentUser(List<SumaryData> sumaryData) {
    _listSumary = sumaryData;
    notifyListeners();
  }

}
