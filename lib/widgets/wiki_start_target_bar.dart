import 'package:flutter/material.dart';
import '../widgets/wiki_label_link.dart';

class WikiStartTargetBar extends StatelessWidget {
  final String startPage;
  final String targetPage;

  const WikiStartTargetBar({
    super.key,
    required this.startPage,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WikiLabelLink(label: 'Start:', value: startPage),
          const Icon(Icons.arrow_forward, size: 18),
          WikiLabelLink(label: 'Target:', value: targetPage),
        ],
      ),
    );
  }
}
