String normalizeTitle(dynamic rawResult) {
  final raw = rawResult?.toString() ?? '';
  if (raw.isEmpty) return '';
  final s = raw.trim();
  if (s.length >= 2 && s.startsWith('"') && s.endsWith('"')) {
    return s.substring(1, s.length - 1).trim();
  }
  return s;
}
