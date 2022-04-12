

import 'package:flutter/foundation.dart';

class NavigationBarItemValue with ChangeNotifier{
  int index;

  void toggle(int index){
    this.index = index;
    notifyListeners();
  }

  NavigationBarItemValue({this.index});
}