import 'package:flutter/material.dart';
import '../models/user.dart';

class AppState extends ChangeNotifier {
  PPUser _currentUser = PPUser(
      userID: '',
      userName: 'default',
      lowercaseName: '',
      age: '',
      dateJoined: DateTime.now(),
      interestPoints: [],
      notifs: [],
      language: 'spanish');
  PPUser get currentUser => _currentUser;
  set currentUser(PPUser value) {
    _currentUser = value;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex {
    return _pageIndex;
  }

  set setpageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
