import 'package:flutter/foundation.dart';

class HomepageProvider extends ChangeNotifier {
  int selectedIndex = 0;

  updateIndex(int val) {
    selectedIndex = val;
    notifyListeners();
  }
}
