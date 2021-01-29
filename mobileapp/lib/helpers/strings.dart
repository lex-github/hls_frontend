import 'package:hls/helpers/null_awareness.dart';

String trimTrailing(String pattern, String from) {
  int i = from.length;
  while (from.startsWith(pattern, i - pattern.length)) i -= pattern.length;
  return from.substring(0, i);
}

String trimLeading(String pattern, String from) {
  if (from.isNullOrEmpty) return '';

  int i = 0;
  while (from.startsWith(pattern, i)) i += pattern.length;
  return from.substring(i);
}

String trimBoth(String pattern, String from) {
  return trimTrailing(pattern, trimLeading(pattern, from));
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1)}";
}
