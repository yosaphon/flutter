import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/UserData.dart';

class UserNotifier with ChangeNotifier {
  UserData _currentUser;

  UserData get currentUser => _currentUser;

  set currentUser(UserData userData) {
    _currentUser = userData;
    notifyListeners();
  }
}
