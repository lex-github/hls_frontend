import 'package:flutter/material.dart';

/// Emulation of Java Enum class.
///
/// Example:
///
/// class Meter<int> extends Enum<int> {
///
///  const Meter(int val) : super (val);
///
///  static const Meter HIGH = const Meter(100);
///  static const Meter MIDDLE = const Meter(50);
///  static const Meter LOW = const Meter(10);
/// }
///
/// and usage:
///
/// assert (Meter.HIGH, 100);
/// assert (Meter.HIGH is Meter);
abstract class Enum<T> extends Object {
  final T _value;

  const Enum(this._value);

  T get value => _value;

  static String string(Enum x) => x.value.toString();

  // @override
  // bool operator ==(Object other) => other is Enum<T> && other.value == value;
  //
  // @override
  // int get hashCode => value.hashCode;
}

class GenericEnum<T> extends Enum<T> {
  final String title;
  final String imageTitle;
  final IconData icon;

  const GenericEnum({value, this.title, this.imageTitle, this.icon})
      : super(value);

  @override
  String toString() => "$title";
}
