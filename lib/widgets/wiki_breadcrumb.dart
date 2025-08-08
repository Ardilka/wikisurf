import 'package:flutter/material.dart';

class WikiBreadcrumb extends StatelessWidget {
  final List<String> trail;
  const WikiBreadcrumb({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 24,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: trail.length,
        separatorBuilder: (_, __) => const Icon(Icons.chevron_right, size: 16),
        itemBuilder: (_, i) => Text(
          trail[i],
          overflow: TextOverflow.fade,
          softWrap: false,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
