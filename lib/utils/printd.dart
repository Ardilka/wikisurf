import 'package:flutter/foundation.dart';

bool debug = true;
void printd(String message) {
  if (debug) {
    if (kDebugMode) {
      print(message);
    }
  }
}
