import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/helpers/colors.dart';

// conversions
String dateToString(
    {dynamic date,
    String input = dateTimeInternalFormat,
    output = dateExternalFormat}) {
  date = toDate(date ?? DateTime.now(), format: input);

  return date == null ? '' : DateFormat(output, 'ru_RU').format(date);
}

String htmlToString(String value) => value.replaceAll(
    RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true), '');
double stringToDouble(String value) =>
    value == null ? null : double.parse(value);
String doubleToString(double value) => value == null ? null : value.toString();
int stringToInt(String value) => value == null ? null : int.parse(value);
String intToString(int value) => value == null ? null : value.toString();
bool stringToBool(String value) =>
    value == null ? false : value != '0' && value != 'false';
String boolToString(bool value) => value == null
    ? null
    : value
        ? '1'
        : '0';
int dateToMilliseconds(DateTime date) => date.microsecondsSinceEpoch;

// coercions
toNull(dynamic value) => null;
String toString(dynamic value) => value == null ? null : value.toString();
int toInt(dynamic value) => value == null
    ? null
    : value is int
        ? value
        : value is double
            ? value.toInt()
            : int.parse(value);
double toDouble(dynamic value) => value == null
    ? null
    : value is double
        ? value
        : value is int
            ? value.toDouble()
            : value.isEmpty
                ? .0
                : double.parse(value.replaceAll(' ', ''));
DateTime toDate(dynamic value, {format = dateTimeInternalFormat}) {
  if (value == null || value is DateTime) return value;

  try {
    return DateFormat(format).parse(value);
  } on FormatException catch (_) {
    //print('toDate ERROR: ($format) $_');

    if (format != dateInternalFormat &&
        (value as String).length == dateInternalFormat.length)
      return toDate(value, format: dateInternalFormat);
    else
      return toDateFromISO8601(value);
  }
}

DateTime toDateFromISO8601(dynamic value) {
  if (value == null || value is DateTime) return value;

  try {
    return DateTime.parse(value);
  } on FormatException catch (e) {
    print('toDateFromISO8601 ERROR: $e');
  }

  return null;
}

List toJsonList(List items) =>
    items.map((item) => item.toJson()).toList(growable: false);

// form transforms
DateTime toDateValue(value) => toDate(value, format: dateExternalFormat);
String toDateString(value) => dateToString(date: value);
String toDateStringInternal(value) => value == null
    ? null
    : dateToString(date: value, output: dateInternalFormat);

Color toColor(value) =>
    value == null ? null : ColorUtility.fromHex(value.toString());
String colorToString(Color color) => color.toHex();
