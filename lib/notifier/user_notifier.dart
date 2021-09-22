import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/UserData.dart';

class UserNotifier with ChangeNotifier {
  List<UserData> _currentUser=[];
  UserData _selectedData;
  List<String> _docID =[];

  UnmodifiableListView<UserData> get currentUser =>
      UnmodifiableListView(_currentUser);

  UnmodifiableListView<String> get docID => UnmodifiableListView(_docID);

  get selectedData => _selectedData;

  set currentUser(List<UserData> userData) {
    _currentUser = userData;
    notifyListeners();
  }

  set docID(List<String> docID) {
    _docID = docID;
    notifyListeners();
  }

  set selectedData(UserData userData) {
    _selectedData = userData;
    notifyListeners();
  }
}
