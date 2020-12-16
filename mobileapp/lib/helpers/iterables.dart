import 'package:hls/helpers/null_awareness.dart';

extension MapGetter on Map {
  T get<T>(key, {defaultValue}) => this == null
      ? null
      : this.containsKey(key)
          ? this[key]
          : defaultValue;

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
