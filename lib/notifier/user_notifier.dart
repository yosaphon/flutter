import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:lotto/model/UserData.dart';
import 'package:lotto/screen/check/qr_scan_page.dart';

class UserNotifier with ChangeNotifier {
  List<UserData> _currentUser = [];
  UserData _selectedData;
  List<String> _docID = [];
  Map<String,UserData> _keyCurrentUser = {};

  QRCodeData _qrcodeData ;

  UnmodifiableListView<UserData> get currentUser =>
      UnmodifiableListView(_currentUser);

  UnmodifiableListView<String> get docID => UnmodifiableListView(_docID);

  UnmodifiableMapView<String,UserData> get keyCurrentUser => UnmodifiableMapView(_keyCurrentUser);

  get selectedData => _selectedData;

  get qrcodeData => _qrcodeData;

  set qrcodeData(QRCodeData qrCodeData) {
    _qrcodeData = qrCodeData;
    notifyListeners();
  }

  set currentUser(List<UserData> userData) {
    _currentUser = userData;
    notifyListeners();
  }
  set keyCurrentUser(Map<String,UserData> keyCurrentUser) {
    _keyCurrentUser = keyCurrentUser;
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
