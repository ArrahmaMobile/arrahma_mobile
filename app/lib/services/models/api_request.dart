import 'package:arrahma_mobile_app/utils/duration_utils.dart';
import 'package:arrahma_mobile_app/utils/enum_utils.dart';
import 'package:flutter/foundation.dart';

import 'api_response.dart';

class ApiRequest<TIn, TOut, TError> {
  ApiRequest(
      {@required this.method,
      @required this.relativeUrl,
      this.baseUrl,
      this.authToken,
      this.timeout,
      this.isInternal,
      this.body});
  final HttpMethod method;
  final String relativeUrl;
  final TIn body;
  final Duration timeout;
  final String authToken;
  final String baseUrl;
  final bool isInternal;

  DateTime startTime;
  Duration duration;
  int contentLength;
  ApiResponse<TOut, TError> response;

  DateTime get endTime =>
      startTime != null && duration != null ? startTime.add(duration) : null;

  @override
  String toString([bool showResponse = true]) {
    return '${(duration?.inSeconds ?? 0) > 15 ? '[!!!WARNING!!!]\n' : ''}[${startTime.toIso8601String()}] ${EnumUtils.enumToStringWithPad(HttpMethod.values, method)} $relativeUrl ${response.statusCode} | ${DurationUtils.durationToString(duration)}${response != null && showResponse ? '\n$response' : ''}';
  }
}

enum HttpMethod { HEAD, GET, POST, PUT, PATCH, DELETE }
