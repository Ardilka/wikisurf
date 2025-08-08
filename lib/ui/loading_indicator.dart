import 'package:flutter/material.dart';
import 'package:wikisurf/ui/wiki_container.dart';

class WikiLoadingIndicator extends StatefulWidget {
  const WikiLoadingIndicator({super.key});

  @override
  State<WikiLoadingIndicator> createState() => _WikiLoadingIndicatorState();
}

class _WikiLoadingIndicatorState extends State<WikiLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WikiContainer(
        child: FadeTransition(
          opacity: _opacity,
          child: const Text(
            'Loading...',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 30,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
