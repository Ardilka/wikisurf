import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void showConfetti(BuildContext context) {
  final controller = ConfettiController(
    duration: const Duration(milliseconds: 1500),
  );

  late OverlayEntry overlay;
  overlay = OverlayEntry(
    builder: (_) =>
        _FadeConfettiWidget(controller: controller, overlayEntry: overlay),
  );

  controller.play();

  Overlay.of(context, rootOverlay: true).insert(overlay);
}

class _FadeConfettiWidget extends StatefulWidget {
  final ConfettiController controller;
  final OverlayEntry overlayEntry;

  const _FadeConfettiWidget({
    required this.controller,
    required this.overlayEntry,
  });

  @override
  State<_FadeConfettiWidget> createState() => _FadeConfettiWidgetState();
}

class _FadeConfettiWidgetState extends State<_FadeConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.controller.dispose();
              _fadeController.dispose();
              widget.overlayEntry.remove();
            }
          });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Sol üstten SAĞA doğru çapraz düşen
              Align(
                alignment: Alignment.topLeft,
                child: _buildConfetti(
                  blastDirection: 2, // 1.57 (aşağı) → 1.2 biraz sağ çapraz
                  colors: const [
                    Colors.pink,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.white,
                  ],
                ),
              ),
              // Sağ üstten SOLA doğru çapraz düşen
              Align(
                alignment: Alignment.topRight,
                child: _buildConfetti(
                  blastDirection: 1.9, // 1.57 (aşağı) → 2.0 biraz sol çapraz
                  colors: const [
                    Colors.pink,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.white,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti({
    required double blastDirection,
    required List<Color> colors,
  }) {
    return ConfettiWidget(
      confettiController: widget.controller,
      blastDirectionality: BlastDirectionality.explosive,
      blastDirection: blastDirection,
      maxBlastForce: 25,
      minBlastForce: 24,
      gravity: 0.7,
      emissionFrequency: 1,
      numberOfParticles: 4,
      shouldLoop: false,
      colors: colors,
    );
  }
}
