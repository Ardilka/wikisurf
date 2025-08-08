import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wikisurf/ui/show_snackbar_top.dart';

import '../utils/wiki_js.dart';
import '../utils/wiki_url.dart';
import '../utils/title_normalizer.dart';

typedef WinCallback = void Function(int steps);

class WikiGameController {
  final String startPage;
  final String targetPage;
  final BuildContext? navContext;

  final WinCallback onWin;
  final VoidCallback onReadyChanged;
  final VoidCallback onTrailChanged;

  late final WebViewController web;
  final List<String> trail = [];
  bool pageReady = false;

  WikiGameController({
    required this.navContext,
    required this.startPage,
    required this.targetPage,
    required this.onWin,
    required this.onReadyChanged,
    required this.onTrailChanged,
  });

  int get moves => trail.isEmpty ? 0 : (trail.length - 1).clamp(0, 1 << 31);

  Future<void> init() async {
    web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains('en.m.wikipedia.org') ||
                url.contains('en.wikipedia.org')) {
              return NavigationDecision.navigate;
            }

            // Show top snackbar warning
            showSnackBarTop(
              navContext!, // we'll store a BuildContext reference
              'Links outside Wikipedia are disabled.',
              durationMs: 1500,
            );

            return NavigationDecision.prevent;
          },
          onPageFinished: (url) async {
            try {
              final raw = await web.runJavaScriptReturningResult(
                WikiJs.titleQuery,
              );
              final pageTitle = normalizeTitle(raw);

              if (pageTitle.isNotEmpty &&
                  (trail.isEmpty || trail.last != pageTitle)) {
                trail.add(pageTitle);
                onTrailChanged();

                if (pageTitle.trim() == targetPage.trim()) {
                  onWin(trail.length);
                }
              }

              await web.runJavaScript(WikiJs.cleanDom);
            } catch (e) {
              debugPrint('JS error: $e');
            } finally {
              if (!pageReady) {
                pageReady = true;
                onReadyChanged();
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(wikiUrl(startPage)));
  }

  void restart() {
    trail.clear();
    pageReady = false;
    onTrailChanged();
    onReadyChanged();
    web.loadRequest(Uri.parse(wikiUrl(startPage)));
  }

  void dispose() {
    // nothing to dispose right now
  }
}
