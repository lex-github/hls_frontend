// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_http_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormValidationData _$FormValidationDataFromJson(Map<String, dynamic> json) {
  return FormValidationData()
    ..fields = (json['fields'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..values = json['values'] as Map<String, dynamic>;
}

Map<String, dynamic> _$FormValidationDataToJson(FormValidationData instance) =>
    <String, dynamic>{
      'fields': instance.fields,
      'values': instance.values,
    };
