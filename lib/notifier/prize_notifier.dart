import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/PredictData.dart';
import 'package:lotto/model/PrizeData.dart';

class PrizeNotifier with ChangeNotifier {
  Map<String, PrizeData> _prizeList = {};
  List<String> _id = [];
  PrizeData _selectedPrize;
  List<String> _listOutDate;

  UnmodifiableMapView<String, PrizeData> get prizeList =>
      UnmodifiableMapView(_prizeList);
  get id => _id;

  PrizeData get selectedPrize => _selectedPrize;

  set prizeList(Map<String, PrizeData> prizeList) {
    _prizeList = prizeList;
    notifyListeners();
  }

  set id(List<String> id) {
    _id = id;
    notifyListeners();
  }

  set selectedPrize(PrizeData prizesData) {
    _selectedPrize = prizesData;
    notifyListeners();
  }

  get listOutDate => _listOutDate;

  set listOutDate(List<String> listOutDate) {
    _listOutDate = listOutDate;
    notifyListeners();
  }

    List<PredictData> _predictData =[];
  get predictData => _predictData;

  set predictData(  List<PredictData> predictData) {
    _predictData = predictData;
    notifyListeners();
  }
}
