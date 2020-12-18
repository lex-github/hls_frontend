import 'package:hls/helpers/null_awareness.dart';

extension MapGetter on Map {
  T get<T>(key, {defaultValue}) {
    if (this == null)
      return defaultValue;

    // key is list
    if (key is List) {
      if (key.length == 0)
        return defaultValue;

      final result = this.get(key.removeAt(0), defaultValue: defaultValue);
      if (key.length == 0)
        return result;

      if (!(result is Map))
        return defaultValue;

      return (result as Map).get(key, defaultValue: defaultValue);
    }

    return this.containsKey(key)
      ? this[key]
      : defaultValue;
  }

  String get queryString => this.keys.fold(
      [], (parameters, key) => parameters..add('$key=${this[key]}')).join('&');
}

extension ListGetter on List {
  dynamic get(int index) => this.isNullOrEmpty
      ? null
      : index < this.length
          ? this[index]
          : null;
  dynamic get firstOrNull => this.isNullOrEmpty ? null : this.first;
}
