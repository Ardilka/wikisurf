import 'package:flutter/material.dart';

class WikiActionBar extends StatelessWidget {
  final int moves;
  final VoidCallback onRestart;

  const WikiActionBar({
    super.key,
    required this.moves,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: onRestart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              side: const BorderSide(color: Colors.black26),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Restart'),
          ),
          Text(
            'Give up   $moves | Time: 00:00',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}
