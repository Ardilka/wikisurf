import 'package:flutter/material.dart';

class WikiLabelLink extends StatelessWidget {
  final String label;
  final String value;

  const WikiLabelLink({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label ',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}
