import 'package:flutter/material.dart';

class SurfBoardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const SurfBoardButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => debugPrint(text),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: CustomPaint(
            painter: _SurfBoardShapePainter(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Georgia',
                  color: Color(0xFF5C3A0C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurfBoardShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    final w = size.width;
    final h = size.height;

    // Sol uçtan başla
    path.moveTo(0, h / 2);

    // Üst kıvrım: sol yukarıdan sağ yukarıya
    path.quadraticBezierTo(w * 0.05, 0, w / 2, 0);

    // Üstten sağ kıvrıma
    path.quadraticBezierTo(w * 0.95, 0, w, h / 2);

    // Alttan sağ kıvrıma
    path.quadraticBezierTo(w * 0.95, h, w / 2, h);

    // Alttan sol kıvrıma
    path.quadraticBezierTo(w * 0.05, h, 0, h / 2);

    path.close();

    final fill = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFD07D), Color(0xFFE59650)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final border = Paint()
      ..color = const Color(0xFFE7C08A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
