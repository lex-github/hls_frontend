import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:hls/constants/api.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/helpers/enums.dart';
import 'package:hls/helpers/iterables.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/services/_service.dart';

part '_http_service.g.dart';

class HttpRequest {
  final String path;
  final RequestMethod method;
  final Map<String, String> headers;
  final Map<String, dynamic> parameters;

  HttpRequest(
      {@required String path,
      this.method = RequestMethod.GET,
      this.headers = const {},
      this.parameters = const {}})
      : this.path = path.startsWith('http') ? path : '${siteUrl}api/$path';

  @override
  String toString() => 'HttpRequest('
      '\n\tpath: $path'
      '\n\tmethod: ${method.value}'
      '\n\tparameters: $parameters'
      ')';
}

class HttpResponse {
  final int status;
  final Map<String, String> headers;
  final Map<String, dynamic> data;
  final String error;

  HttpResponse({this.status, this.headers, this.data, String error})
      : this.error =
            error ?? ((m) => m is List ? m.join(', ') : m)(data.get('message'));

  String getHeader(String header) => headers?.get(header);
  bool get valid => error.isNullOrEmpty && data != null;

  @override
  String toString() => 'HttpResponse('
      '\n\tstatus: $status'
      '\n\theaders: $headers'
      '\n\terror: $error'
      '\n\tdata: $data)';
}

class HttpService extends Service {
  static HttpService get i => Get.find<HttpService>();

  http.Client client;

  @override
  void onInit() {
    super.onInit();
    this.client = http.Client();
  }

  @override
  void onClose() {
    super.onClose();
    this.client.close();
  }

  Future<HttpResponse> request(HttpRequest request) async {
    if (isDebug && false) print('HttpService.request request: $request');

    final path = request.method == RequestMethod.GET
        ? request.path +
            ((String queryString) => queryString.isNullOrEmpty
                ? ''
                : '?$queryString')(request.parameters.queryString)
        : request.path;

    final rq = http.Request(request.method.value, Uri.parse(path))
      ..headers
          .addAll({'Content-Type': 'application/json', ...request.headers});

    switch (request.method) {
      case RequestMethod.GET:
        break;
      default:
        rq.body = jsonEncode(request.parameters);
    }

    try {
      final streamedResponse = await client.send(rq).timeout(timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.body.isNullOrEmpty)
        return HttpResponse(status: response.statusCode);

      //final body = jsonDecode(response.body);
      final body = json.decode(utf8.decode(response.bodyBytes));
      final data = body is List ? {'list': body} : body;

      if (isDebug) print('HttpService.request data: $data');

      return HttpResponse(
          status: response.statusCode, headers: response.headers, data: data);
    } on TimeoutException catch (e) {
      print('HttpService.request ERROR (timeout): $e');

      return HttpResponse(
          error: timeoutExceptionText.replaceAll(
              '{duration}', timeoutDuration.inSeconds.toString()));
    } on SocketException catch (e) {
      print('HttpService.request ERROR (socket): $e');

      return HttpResponse(error: connectionExceptionText);
    } on FormatException catch (e) {
      print('HttpService.request ERROR (format): $e');

      return HttpResponse(error: formatExceptionText);
    }
  }
}

@JsonSerializable()
class FormValidationData {
  Map<String, String> fields;
  Map<String, dynamic> values;

  FormValidationData();

  bool get hasErrors => (fields?.length ?? 0) > 0;
  String get messages =>
      fields?.keys?.map((field) => getMessage(field))?.join('\n') ?? '';
  String getMessage(String field) => (fields ?? const {})[field];
  String getMessageForValue(String field, dynamic value) =>
      value != (values ?? const {})[field] ? null : getMessage(field);

  factory FormValidationData.fromJson(Map<String, dynamic> json) =>
      _$FormValidationDataFromJson(json);
  Map<String, dynamic> toJson() => _$FormValidationDataToJson(this);
}

class RequestMethod<String> extends Enum<String> {
  const RequestMethod(v) : super(v);

  static const DELETE = const RequestMethod('DELETE');
  static const GET = const RequestMethod('GET');
  static const PATCH = const RequestMethod('PATCH');
  static const POST = const RequestMethod('POST');
  static const PUT = const RequestMethod('PUT');
}
