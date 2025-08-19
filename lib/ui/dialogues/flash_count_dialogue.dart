import 'package:flutter/material.dart';
import 'package:wikisurf/ui/flash_icons_row.dart';
import 'package:wikisurf/utils/flash_manager.dart';

void showFlashCount(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true, // 🚫 cannot tap outside
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: FlashRow(),
      content: Text(
        flashes.getRegenerationProgress().toString(),
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
