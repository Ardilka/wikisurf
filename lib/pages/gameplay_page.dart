import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikisurf/ui/flash_icons_row.dart';
import 'package:wikisurf/ui/loading_indicator.dart';
import 'package:wikisurf/ui/show_confetti.dart';
import 'package:wikisurf/widgets/wiki_start_target_bar.dart';
import '../controllers/wiki_game_controller.dart';
import '../widgets/wiki_breadcrumb.dart';
import '../widgets/wiki_action_bar.dart';

class WikiSurfGamePage extends StatefulWidget {
  final String startPage;
  final String targetPage;

  const WikiSurfGamePage({
    super.key,
    required this.startPage,
    required this.targetPage,
  });

  @override
  State<WikiSurfGamePage> createState() => _WikiSurfGamePageState();
}

class _WikiSurfGamePageState extends State<WikiSurfGamePage> {
  late final WikiGameController _game;
  Future<bool?> _confirmLeave(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text(
          'Are you sure you want to leave? Your current progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _game = WikiGameController(
      navContext: context,
      startPage: widget.startPage,
      targetPage: widget.targetPage,
      onWin: (steps) async {
        if (!mounted) return;
        showConfetti(context);
        await showDialog<void>(
          context: context,
          barrierDismissible: false, // 🚫 cannot tap outside
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Congratulations!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'You reached ${widget.targetPage} in $steps steps.',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // back to levels page
                },
                child: const Text('Back to Levels'),
              ),
            ],
          ),
        );
      },
      onReadyChanged: () => setState(() {}),
      onTrailChanged: () => setState(() {}),
    )..init();
  }

  @override
  void dispose() {
    _game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moves = _game.moves;

    return PopScope(
      canPop: false, // disable auto pop, we handle manually
      onPopInvoked: (didPop) async {
        if (didPop) return; // already popped somewhere else
        final shouldLeave = await _confirmLeave(context);
        if (shouldLeave == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldLeave = await _confirmLeave(context);
              if (shouldLeave == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            FlashRow(),
            // Padding(
            //   padding: const EdgeInsets.only(right: 20.0),
            //   child: WikiAppBarMoves(moves: moves),
            // ),
          ],
          title: const Text(
            'WikiSurf',
            style: TextStyle(
              fontFamily: 'Georgia',
              color: Colors.black87,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Divider(height: 1),
                WikiStartTargetBar(
                  startPage: widget.startPage,
                  targetPage: widget.targetPage,
                ),
                const Divider(height: 1),
                SizedBox(height: 24, child: WikiBreadcrumb(trail: _game.trail)),
                const Divider(height: 1),

                Expanded(
                  child: _game.pageReady
                      ? WebViewWidget(controller: _game.web)
                      : const Center(child: WikiLoadingIndicator()),
                ),

                const Divider(height: 1),

                WikiActionBar(moves: moves, onRestart: _game.restart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
