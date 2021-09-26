import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/UserData.dart';

class UserSumaryNotifier with ChangeNotifier {
  List<UserData> _userSumary=[];

  List<String> _docID =[];

  UnmodifiableListView<UserData> get userSumary =>
      UnmodifiableListView(_userSumary);

  UnmodifiableListView<String> get docID => UnmodifiableListView(_docID);



  set userSumary(List<UserData> userData) {
    _userSumary = userData;
    notifyListeners();
  }


 
}
