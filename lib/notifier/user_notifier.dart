import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/UserData.dart';

class UserNotifier with ChangeNotifier {
  List<UserData> _userList = [];
  UserData _currentUser;

  UnmodifiableListView<UserData> get userList =>UnmodifiableListView(_userList);

  UserData get currentUser => _currentUser;

  set userList(List<UserData> userList) {
    _userList = userList;
    notifyListeners();
  }

  set currentUser(UserData userData) {
    _currentUser = userData;
    notifyListeners();
  }
}
