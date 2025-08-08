import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void showSnackBarTop(
  BuildContext context,
  String text, {
  int durationMs = 500,
}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(message: text),
    displayDuration: Duration(milliseconds: durationMs),
  );
}
