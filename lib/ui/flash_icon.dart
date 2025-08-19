import 'package:flutter/material.dart';
import 'package:wikisurf/ui/dialogues/flash_count_dialogue.dart';

class FlashIcon extends StatelessWidget {
  final double percentage; // Value between 0 and 100

  const FlashIcon({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFlashCount(context);
        // Handle flash tap if needed
      },
      child: SizedBox(
        width: 20,
        child: Stack(
          children: [
            Icon(
              Icons.flash_on,
              size: 22,
              color: Colors.grey.withValues(alpha: 0.3), // Background Flash
            ),
            ClipRect(
              clipper: PercentageClipper((percentage * 0.75 + 11)),
              child: Icon(
                Icons.flash_on,
                size: 22,
                color: percentage == 100
                    ? wikiBlue // Full Flash
                    : wikiBlue.withValues(alpha: 0.5), // Foreground Flash
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PercentageClipper extends CustomClipper<Rect> {
  final double percentage;

  PercentageClipper(this.percentage);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0,
      size.height * (1 - (percentage / 100)),
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

const Color wikiBlue = Color(0xFF2965CA);
