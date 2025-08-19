import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikisurf/utils/printd.dart';

final flashes = FlashManager(regenMinutes: 20); // dakika cinsinden

enum FlashesState { full, regenerating, empty }

class FlashManager {
  static const int maxFlashes = 5;
  static const String _lossKeyPrefix = 'flash_loss_';
  final Duration regenDuration;
  final Map<int, DateTime> lastLossTime = {}; // flash index -> lost time
  SharedPreferences? _prefs;

  FlashManager({required int regenMinutes})
    : regenDuration = Duration(minutes: regenMinutes);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    for (var i = 1; i <= maxFlashes; i++) {
      final key = '$_lossKeyPrefix$i';
      if (_prefs!.containsKey(key)) {
        lastLossTime[i] = DateTime.parse(_prefs!.getString(key)!);
      }
    }
    pruneFullyRegenerated();
  }

  Future<void> resetFlashes() async {
    final prefs = await SharedPreferences.getInstance();
    for (var i = 1; i <= maxFlashes; i++) {
      prefs.remove('$_lossKeyPrefix$i');
    }
    lastLossTime.clear();
  }

  void loseFlash() {
    pruneFullyRegenerated();

    if (lastLossTime.length >= maxFlashes) return;

    // En büyük dolu kalbi kaybet (3→2→1)
    final existingLost = lastLossTime.keys.toSet();
    int toLose = -1;
    for (int i = maxFlashes; i >= 1; i--) {
      if (!existingLost.contains(i)) {
        toLose = i;
        break;
      }
    }
    if (toLose == -1) return;

    final now = DateTime.now();
    lastLossTime[toLose] = now;
    _prefs?.setString('$_lossKeyPrefix$toLose', now.toIso8601String());
  }

  /// Zinciri simüle eder ve tam dolmuş kalpleri temizler.
  void pruneFullyRegenerated() {
    if (lastLossTime.isEmpty) return;
    final now = DateTime.now();

    final chain = _buildChain(); // sorted by loss time asc
    DateTime? prevFinish;
    final toRemove = <int>[];

    for (final entry in chain) {
      final idx = entry.key;
      final lostAt = entry.value;

      final start = prevFinish == null
          ? lostAt
          : (prevFinish.isAfter(lostAt) ? prevFinish : lostAt);
      final finish = start.add(regenDuration);

      if (now.isAfter(finish) || now.isAtSameMomentAs(finish)) {
        toRemove.add(idx);
        prevFinish = finish;
      } else {
        // bu kalp tamamlanmamış, zincir burada durur
        break;
      }
    }

    for (var idx in toRemove) {
      lastLossTime.remove(idx);
      _prefs?.remove('$_lossKeyPrefix$idx');
    }
  }

  /// Kalbin durumunu zincire göre hesaplar, yan etki yapmaz.
  FlashesState getFlashesState(int index) {
    if (!lastLossTime.containsKey(index)) return FlashesState.full;

    final now = DateTime.now();
    final chain = _buildChain();
    DateTime? prevFinish;

    for (final entry in chain) {
      final idx = entry.key;
      final lostAt = entry.value;
      final start = prevFinish == null
          ? lostAt
          : (prevFinish.isAfter(lostAt) ? prevFinish : lostAt);
      final finish = start.add(regenDuration);

      if (idx == index) {
        if (now.isAfter(finish) || now.isAtSameMomentAs(finish)) {
          return FlashesState.full;
        } else if (now.isBefore(start)) {
          return FlashesState.empty;
        } else {
          return FlashesState.regenerating;
        }
      }

      if (now.isAfter(finish) || now.isAtSameMomentAs(finish)) {
        prevFinish = finish;
        continue;
      } else {
        break;
      }
    }

    return FlashesState.empty;
  }

  double getFlashFullness(int index) {
    if (!lastLossTime.containsKey(index)) return 100.0;

    final now = DateTime.now();
    final chain = _buildChain();
    DateTime? prevFinish;

    for (final entry in chain) {
      final idx = entry.key;
      final lostAt = entry.value;
      final start = prevFinish == null
          ? lostAt
          : (prevFinish.isAfter(lostAt) ? prevFinish : lostAt);
      final finish = start.add(regenDuration);

      if (idx == index) {
        if (now.isAfter(finish) || now.isAtSameMomentAs(finish)) {
          return 100.0;
        } else if (now.isBefore(start)) {
          return 0.0;
        } else {
          final passed = now.difference(start);
          return (passed.inMilliseconds / regenDuration.inMilliseconds).clamp(
                0.0,
                1.0,
              ) *
              100.0;
        }
      }

      if (now.isAfter(finish) || now.isAtSameMomentAs(finish)) {
        prevFinish = finish;
        continue;
      } else {
        break;
      }
    }

    return 0.0;
  }

  /// Returns a list of flash indices sorted by fullness descending.
  /// visualIndex = 0 means most full, 2 means least full.
  List<int> getFlashOrderByFullness() {
    final Map<int, double> map = {};
    for (int i = 1; i <= maxFlashes; i++) {
      map[i] = getFlashFullness(i);
    }

    final sorted = map.entries.toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        if (cmp != 0) return cmp;
        return a.key.compareTo(b.key);
      });

    return sorted.map((e) => e.key).toList(); // return indices in order
  }

  /// Returns the fullness (0..100) of the Nth most-full flash.
  /// For UI display purposes.
  double getFlashFullnessAtPosition(int visualIndex) {
    final order = getFlashOrderByFullness();
    if (visualIndex < 0 || visualIndex >= order.length) return 0.0;
    return getFlashFullness(order[visualIndex]);
  }

  /// Returns the original flash index (1..3) for the visual slot [visualIndex].
  int getFlashIndexAtPosition(int visualIndex) {
    final order = getFlashOrderByFullness();
    if (visualIndex < 0 || visualIndex >= order.length) return -1;
    return order[visualIndex];
  }

  bool hasAnyFullFlashes() {
    pruneFullyRegenerated();
    return currentFlashes > 0;
  }

  int get currentFlashes {
    pruneFullyRegenerated();
    return maxFlashes - lastLossTime.length;
  }

  double getRegenerationProgress() {
    final now = DateTime.now();
    final chain = _buildChain();
    DateTime? prevFinish;

    for (final entry in chain) {
      final lostAt = entry.value;
      final start = prevFinish == null
          ? lostAt
          : (prevFinish.isAfter(lostAt) ? prevFinish : lostAt);
      final finish = start.add(regenDuration);

      if (now.isBefore(start)) {
        return 0.0;
      }
      if (now.isBefore(finish)) {
        final passed = now.difference(start);
        return (passed.inMilliseconds / regenDuration.inMilliseconds).clamp(
          0.0,
          1.0,
        );
      }

      prevFinish = finish;
    }
    return 0.0;
  }

  List<MapEntry<int, DateTime>> _buildChain() {
    final entries = lastLossTime.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return entries;
  }

  void debugPrintFlashStatus() {
    pruneFullyRegenerated();
    printd("🧠 [FlashManager DEBUG STATUS]");
    printd("→ currentFlashes: $currentFlashes");
    printd("→ hasAnyFullFlashes(): ${hasAnyFullFlashes()}");
    printd("→ lastLossTime (RAM):");
    lastLossTime.forEach((k, v) {
      printd("   - Flash $k lost at: $v");
    });
    printd("→ SharedPreferences:");
    for (var i = 1; i <= maxFlashes; i++) {
      final key = '$_lossKeyPrefix$i';
      final val = _prefs?.getString(key);
      printd("   - $key -> ${val ?? 'null'}");
    }
    for (var i = 1; i <= maxFlashes; i++) {
      printd(
        "   - Flash $i: ${getFlashesState(i)} | ${getFlashFullness(i).toStringAsFixed(1)}%",
      );
    }
    printd("→ Regen progress (current): ${getRegenerationProgress()}");
    printd("🧠 [END]");
  }
}
