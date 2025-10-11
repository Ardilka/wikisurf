import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wikisurf/ui/dialogues/flash_count_dialogue.dart';
import 'package:wikisurf/ui/flash_icon.dart';
import 'package:wikisurf/utils/flash_manager.dart';

class FlashRow extends StatefulWidget {
  final bool showsDialog;
  const FlashRow({super.key, this.showsDialog = true});

  @override
  State<FlashRow> createState() => _FlashRowState();
}

class _FlashRowState extends State<FlashRow> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.showsDialog) {
          // Show the flash info dialog when tapped
          showFlashInfoDialog(context);
        }
        // Handle flash tap if needed
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(FlashManager.maxFlashes, (i) {
            final percentage = flashes.getFlashFullnessAtPosition(i);
            return FlashIcon(percentage: percentage);
          }),
        ),
      ),
    );
  }
}
