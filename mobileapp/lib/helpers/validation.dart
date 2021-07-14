import 'package:flutter/foundation.dart';
import 'package:form_field_validator/form_field_validator.dart'
    hide EmailValidator, RequiredValidator;
import 'package:get/utils.dart';
import 'package:hls/constants/formats.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/convert.dart';
import 'package:hls/helpers/null_awareness.dart';

class AnythingValidator extends TextFieldValidator {
  AnythingValidator() : super('');

  @override
  bool isValid(_) => true;

  @override
  String call(dynamic _) => null;
}

class EmailValidator extends TextFieldValidator {
  /// regex pattern to validate email inputs.
  final Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidator({String errorText = errorEmailText}) : super(errorText.tr);

  @override
  bool isValid(String value) =>
      value.isNullOrEmpty || hasMatch(_emailPattern, value);
}

class EmailOrPhoneValidator extends TextFieldValidator {
  /// regex patterns
  final Pattern _emailPattern = emailValidationPattern;
  final Pattern _phonePattern = phoneValidationPattern;

  EmailOrPhoneValidator({String errorText = errorEmailOrPhoneText})
      : super(errorText.tr);

  @override
  bool isValid(String value) =>
      value.isNullOrEmpty ||
      hasMatch(_emailPattern, value) ||
      hasMatch(_phonePattern, value);
}

class RequiredValidator extends TextFieldValidator {
  RequiredValidator({String errorText = errorRequiredText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(dynamic value) =>
      value != null && (!(value is String) || value.isNotEmpty);

  @override
  String call(dynamic value) => isValid(value) ? null : errorText.tr;
}

class LengthMatchValidator extends TextFieldValidator {
  final int length;

  LengthMatchValidator(
      {@required this.length, String errorText = errorExactLengthText})
      : super(errorText.replaceAll('{length}', length.toString()));

  @override
  bool isValid(String value) => value.length == length;
}

class MinLengthValidator extends TextFieldValidator {
  final int min;

  MinLengthValidator(
      {@required this.min, String errorText = errorMinLengthText})
      : super(errorText.tr.replaceAll('{min}', min.toString()));

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) => value.length == 0 || value.length >= min;
}

class DateValidator extends TextFieldValidator {
  final format;

  DateValidator({this.format = dateExternalFormat})
      : super(errorDateText.tr.replaceAll('{format}', format));

  @override
  bool isValid(value) =>
      value.isNullOrEmpty ||
      value ==
          dateToString(date: toDate(value, format: format), output: format);
}

class PhoneValidator extends PatternValidator {
  PhoneValidator()
      : super(phoneValidationPattern, errorText: errorPhoneText.tr);
}

class DateTimeValidator extends PatternValidator {
  DateTimeValidator()
      : super(dateTimeValidationPattern,
            errorText: errorDateText.tr.replaceAll('{format}', dateTimeFull));
}

class NumericValidator extends PatternValidator {
  NumericValidator() : super(r'^\d+$', errorText: errorNumericText.tr);
}

class TypeValidator<T> extends FieldValidator<T> {
  TypeValidator({String errorText = errorTypeText})
      : super(errorText.replaceAll('{type}', T.toString()));

  @override
  bool isValid(dynamic value) => value is T || value is List<T>;
}

class UnchangedValueValidator extends FieldValidator {
  final prevValue;

  UnchangedValueValidator(
      {@required this.prevValue, @required String errorText})
      : super(errorText);

  @override
  bool isValid(dynamic value) => value != prevValue;
}

class MultiValidatorWithError extends MultiValidator {
  MultiValidatorWithError(validators) : super(validators);

  String _errorText;
  @override
  String get errorText => _errorText;

  @override
  bool isValid(value) {
    for (FieldValidator validator in validators) {
      if (validator == null)
        continue;

      if (!validator.isValid(value)) {
        _errorText = validator.errorText;
        return false;
      }
    }

    return true;
  }

  @override
  String call(dynamic value) {
    final result = isValid(value) ? null : _errorText;

    // print('MultiValidatorWithError.call'
    //   '\n\tvalue: $value'
    //   '\n\tresult: $result');

    return result;
  }
}

// project validators

final textValidator = MultiValidatorWithError([
  RequiredValidator(),
]);

// auth
final loginValidator =
    MultiValidatorWithError([RequiredValidator(), EmailOrPhoneValidator()]);
final passwordValidator = MultiValidatorWithError(
    [RequiredValidator(), MinLengthValidator(min: minPasswordLength)]);

// otp
final phoneValidator =
    MultiValidatorWithError([RequiredValidator(), PhoneValidator()]);
final codeValidator = MultiValidatorWithError([
  RequiredValidator(),
  //NumericValidator(),
  LengthMatchValidator(length: codeMaskPattern.length)
]);

// chat
final getChatInputValidator = (String pattern) => MultiValidatorWithError([
      RequiredValidator(),
      if (!pattern.isNullOrEmpty)
        PatternValidator(pattern, errorText: errorGenericText)
    ]);

// timer
final timerValidator = MultiValidatorWithError([
  RequiredValidator(),
  NumericValidator()
]);

// exercise
final heartRateValidator = MultiValidatorWithError([
  RequiredValidator(),
  NumericValidator()
]);