import 'package:flutter/material.dart';

class WikiAppBarMoves extends StatelessWidget {
  final int moves;
  const WikiAppBarMoves({super.key, required this.moves});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$moves',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          moves == 1 ? 'step' : 'steps',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
