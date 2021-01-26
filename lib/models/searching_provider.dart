import 'package:flutter/foundation.dart';

class Searching extends ChangeNotifier {
  bool querySubmitted = false;
  bool searching = true;

  updateSearching() {
    searching = !searching;
    notifyListeners();
  }

  updateVarTrue() {
    querySubmitted = true;
    notifyListeners();
  }

  updateVarFalse() {
    querySubmitted = false;
    notifyListeners();
  }
}
