import 'package:hls/helpers/null_awareness.dart';

extension MapGetter on Map {
  T get<T>(key, {defaultValue, Function(dynamic) convert}) {
    if (this == null) return defaultValue;
    //print('key: $key convert: $convert');

    // key is list
    if (key is List) {
      if (key.length == 0) return defaultValue;

      final result = this
          .get(key.removeAt(0), defaultValue: defaultValue, convert: convert);
      //print('result: $result isint: ${result is int}');
      if (key.length == 0) return convert != null ? convert(result) : result;

      if (!(result is Map)) return defaultValue;

      return (result as Map)
          .get(key, defaultValue: defaultValue, convert: convert);
    }

    return this.containsKey(key) ? this[key] : defaultValue;
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
