import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wikisurf/ui/flash_icons_row.dart';
import 'package:wikisurf/utils/flash_manager.dart';

void showFlashInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _FlashInfoDialog(),
  );
}

class _FlashInfoDialog extends StatefulWidget {
  const _FlashInfoDialog();

  @override
  State<_FlashInfoDialog> createState() => _FlashInfoDialogState();
}

class _FlashInfoDialogState extends State<_FlashInfoDialog> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = flashes.currentFlashes; // 0..5
    final total = FlashManager.maxFlashes;
    final nextDur = flashes.timeUntilNextFlash(); // null => tam dolu
    final fullDur = flashes.timeUntilFull(); // null => tam dolu
    // final progress = flashes.currentCycleProgress(); // 0..1

    // Metin tabanlı, sade bilgi. İkon/row dizmeden RichText/Column ile veriyoruz.
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Flashes",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "$current / $total",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                FlashRow(
                  showsDialog: false, // Dialog içinde zaten gösteriyoruz
                ),

                if (nextDur != null) ...[
                  const SizedBox(height: 16),
                  _InfoLine(
                    heading: "Next Flash",
                    value: flashes.formatMinSec(nextDur),
                  ),
                ],

                if (fullDur != null) ...[
                  const SizedBox(height: 8),
                  _InfoLine(
                    heading: "Until Full",
                    value: flashes.formatHourMin(fullDur),
                  ),
                ],

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.bolt),
                      label: const Text("Fill All"),
                      onPressed: () {},
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.all_inclusive),
                      label: const Text("Get Unlimited"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // sağ üst çarpı
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String heading;
  final String value;
  const _InfoLine({required this.heading, required this.value});

  @override
  Widget build(BuildContext context) {
    final stHeading = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700);
    final stValue = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600);

    // İkon/row dizmeden, iki satır metin:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(heading, style: stHeading),
        const SizedBox(height: 2),
        Text(value, style: stValue),
      ],
    );
  }
}
