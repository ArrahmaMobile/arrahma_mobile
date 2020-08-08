import 'dart:async';
import 'dart:io' as io;

import 'package:arrahma_mobile_app/utils/app_utils.dart';
import 'package:arrahma_mobile_app/utils/map_utils.dart';
import 'package:arrahma_mobile_app/utils/models/device_config.dart';
import 'package:arrahma_mobile_app/utils/screen_utils.dart';
import 'package:arrahma_mobile_app/utils/url_utils.dart';
import 'package:arrahma_mobile_app/utils/wrap_list.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' hide BaseResponse;
import 'package:inherited_state/inherited_state.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

import 'connectivity.dart';
import 'logger.dart';
import 'models/api_request.dart';
import 'models/api_response.dart';
import 'models/connection.dart';
import 'models/environment_config.dart';
import 'models/http_status_code.dart';
import 'models/log_event.dart';
import 'models/server_status_check.dart';

class ApiService {
  ApiService(this._environmentConfig, this._connectivityService,
      {this.deviceSize});

  final ConnectivityService _connectivityService;
  final ReactiveController<EnvironmentConfig> _environmentConfig;
  EnvironmentConfig get _environment => _environmentConfig.state;
  String authToken;
  final _deviceConfig = SL.get<DeviceConfig>();

  final Size deviceSize;

  final _cachedRequestResultMap =
      <ApiRequest<dynamic, dynamic, dynamic>, ApiResponse<dynamic, dynamic>>{};
  final _cachedLatestRequestMap = <ApiRequest<dynamic, dynamic, dynamic>,
      ApiRequest<dynamic, dynamic, dynamic>>{};

  final Set<void Function(ApiRequest<dynamic, dynamic, dynamic>)>
      _responseObservers = {};

  int totalRequests = 0;
  int totalDataSent = 0;
  int totalDataReceived = 0;
  int totalDurationMs = 0;

  final requests = WrapList<ApiRequest<dynamic, dynamic, dynamic>>(100);
  ApiRequest<dynamic, dynamic, dynamic> get lastRequest =>
      requests.list.isNotEmpty ? requests.latest : null;

  void _resetMetricsAndRequests() {
    requests.clear();
    totalRequests = 0;
    totalDataSent = 0;
    totalDataReceived = 0;
    totalDurationMs = 0;
  }

  void addObserver(
      void Function(ApiRequest<dynamic, dynamic, dynamic>) observer) {
    _responseObservers.add(observer);
  }

  void removeObserver(
      void Function(ApiRequest<dynamic, dynamic, dynamic>) observer) {
    _responseObservers.remove(observer);
  }

  Future<T> get<T>(String relativeUrl, {String authToken}) async {
    return _getResponse<T>(
        await getWithResponse(relativeUrl, authToken: authToken));
  }

  Future<ApiResponse<T, dynamic>> getWithResponse<T>(String relativeUrl,
      {Duration timeout,
      Duration cacheDuration,
      String authToken,
      bool internal = false}) async {
    return await _sendGetRequest(relativeUrl,
        timeout: timeout,
        cacheDuration: cacheDuration,
        authToken: authToken,
        internal: internal);
  }

  Future<ApiResponse<T, dynamic>> _sendGetRequest<T>(String relativeUrl,
      {Duration timeout,
      Duration cacheDuration,
      String authToken,
      bool internal = false}) {
    return _sendRequest<T>(
      ApiRequest<dynamic, T, dynamic>(
        authToken: authToken,
        baseUrl: baseUrl,
        method: HttpMethod.GET,
        relativeUrl: relativeUrl,
        timeout: timeout,
        isInternal: internal,
      ),
      cacheDuration: cacheDuration,
    );
  }

  Future<T> post<T>(String relativeUrl, dynamic data,
      {bool internal = false, Duration cacheDuration, String authToken}) async {
    return _getResponse<T>(await postWithResponse(relativeUrl, data,
        internal: internal,
        cacheDuration: cacheDuration,
        authToken: authToken));
  }

  Future<ApiResponse<T, dynamic>> postWithResponse<T>(
      String relativeUrl, dynamic data,
      {bool internal = false, Duration cacheDuration, String authToken}) async {
    return await _sendPostRequest<T>(relativeUrl, data,
        internal: internal, cacheDuration: cacheDuration, authToken: authToken);
  }

  Future<ApiResponse<T, dynamic>> _sendPostRequest<T>(
      String relativeUrl, dynamic data,
      {Duration timeout,
      bool internal = false,
      Duration cacheDuration,
      String authToken}) {
    return _sendRequest<T>(
      ApiRequest<dynamic, T, dynamic>(
        authToken: authToken,
        baseUrl: baseUrl,
        method: HttpMethod.POST,
        relativeUrl: relativeUrl,
        body: data,
        isInternal: internal,
        timeout: timeout,
      ),
      cacheDuration: cacheDuration,
    );
  }

  Future<ApiResponse<T, dynamic>> _sendRequest<T>(
      ApiRequest<dynamic, T, dynamic> request,
      {Map<String, String> headers,
      Duration cacheDuration,
      bool useBaseHeaders = true}) async {
    final baseUrl = request.baseUrl ?? this.baseUrl;
    final normalizedUrl = getUrl(request.relativeUrl, baseUrl);
    final isSameBaseUrl = () => normalizedUrl.startsWith(this.baseUrl);

    if (isSameBaseUrl() &&
        !request.isInternal &&
        _connectivityService.latestDeviceResult ==
            DeviceConnectionSource.None) {
      final response = _defaultResponseBase<T, dynamic>(
        null,
        httpStatusCodeMap[HttpStatus.NoDeviceConnection],
        0,
        {},
        message: 'Device is not connected to the internet.',
      );
      request.response = response;
      _logRequest(request, true);
      return response;
    }

    Future<Response> responseFuture;
    request.startTime = DateTime.now();
    if (useBaseHeaders) headers = getHeaders()..addAll(headers ?? {});
    if (request.authToken != null) {
      headers['Authorization'] = createBearerToken(request.authToken);
    }
    if (lastRequest != null &&
        lastRequest == request &&
        request.startTime.difference(lastRequest.startTime) <
            const Duration(milliseconds: 100)) {
      final response = _defaultResponseBase<T, dynamic>(
          null, httpStatusCodeMap[HttpStatus.DuplicateRequest], 0, {},
          message:
              'Duplicate request attempted in a short succession (< 100ms).');
      request.response = response;
      _logRequest(request, true);
      return response;
    }

    bool useCache = false;
    if (cacheDuration != null) {
      final latestRequest =
          _cachedLatestRequestMap[request] as ApiRequest<dynamic, T, dynamic>;
      final cachedResult =
          _cachedRequestResultMap[latestRequest] as ApiResponse<T, dynamic>;
      useCache = cachedResult != null &&
          request.startTime.difference(latestRequest.endTime) < cacheDuration;
      if (useCache) {
        _logRequest(latestRequest, true, true);
        return cachedResult;
      }
    }

    requests.add(request);

    try {
      switch (request.method) {
        case HttpMethod.GET:
          responseFuture = http.get(normalizedUrl, headers: headers);
          break;
        case HttpMethod.POST:
          final body =
              request.body != null ? JsonMapper.serialize(request.body) : null;
          request.contentLength = body?.length;
          responseFuture =
              http.post(normalizedUrl, headers: headers, body: body);
          break;
        default:
          break;
      }
    } catch (err) {
      final response = _defaultResponseBase<T, dynamic>(
        null,
        httpStatusCodeMap[HttpStatus.LocalProcessingException],
        0,
        {},
        message: err.toString(),
      );
      request.response = response;
      _logRequest(request, true);
      return response;
    }

    request.contentLength ??= 0;

    try {
      final response = await responseFuture
          .timeout(request.timeout ?? const Duration(seconds: 30));
      final now = DateTime.now();
      // final dateHeader = response.headers['date'];
      // if (dateHeader != null) {
      //   request.serverResponseTime = DateUtils.parseHttpDate(dateHeader);
      //   if (serverTimeOffset != null)
      //     request.serverResponseTime =
      //         request.serverResponseTime.subtract(serverTimeOffset);
      // }

      request.duration = now.difference(request.startTime);

      final serverResponse = await _parseResponse<T, dynamic>(response);
      if (cacheDuration != null) {
        _cachedLatestRequestMap[request] = request;
        _cachedRequestResultMap[request] = serverResponse;
      }

      request.response = serverResponse;
      return serverResponse;
    } catch (err) {
      if (err is ApiResponse<T, dynamic>) {
        if (err.statusCode == 404 && err.headers['connection'] == 'close') {
          final response = _defaultResponseBase<T, dynamic>(
            null,
            httpStatusCodeMap[HttpStatus.ServerUnreachable],
            err.contentLength,
            err.headers,
            message: err.errorMessage,
          );
          request.response = response;
          throw response;
        }
        request.response = err;
        rethrow;
      } else {
        final status = ExceptionStatusMap[err.runtimeType] ??
            HttpStatus.LocalProcessingException;
        final response = _defaultResponseBase<T, dynamic>(
            null, httpStatusCodeMap[status], 0, {},
            message: err.toString());
        request.response = response;
        throw response;
      }
    } finally {
      request.duration ??= DateTime.now().difference(request.startTime);

      if (!request.isInternal && isSameBaseUrl()) {
        // Roundtrip speed
        totalRequests++;
        totalDataSent += request.contentLength ?? 0;
        totalDataReceived += request.response?.contentLength ?? 0;
        totalDurationMs += request.duration?.inMilliseconds ?? 0;
        _responseObservers.forEach((observerFn) {
          try {
            observerFn(request);
          } catch (err) {
            logger.error('Observer error', err);
          }
        });
      }

      _logRequest(request);
    }
  }

  void _logRequest<T>(ApiRequest<dynamic, T, dynamic> request,
      [bool ignoreResponseSuccess = false, bool isCached = false]) {
    logger.log(LogEvent.from(
        level: ignoreResponseSuccess || request.response.isSuccess
            ? (request.duration?.inSeconds ?? 0) > 15
                ? LogLevel.Warning
                : LogLevel.Info
            : LogLevel.Error,
        message: request.toString(isCached)));
  }

  Future<T> _getResponse<T>(ApiResponse<T, dynamic> response) async {
    return response.data;
  }

  static const ExceptionStatusMap = <Type, HttpStatus>{
    io.SocketException: HttpStatus.ServerUnreachable,
    TimeoutException: HttpStatus.TimeoutError,
  };

  Future<ApiResponse<ServerStatusCheck, void>> getStatus(
      {bool internal = false}) {
    return getWithResponse('api/status');
  }

  Future<ApiResponse<TData, TError>> _parseResponse<TData, TError>(
      Response response) {
    ApiResponse<TData, TError> retResponse =
        _defaultResponse<TData, TError>(null, response);
    try {
      if (isSuccess(response)) {
        if (response?.body?.isNotEmpty ?? false) {
          final data = JsonMapper.deserialize<TData>(response.body);
          retResponse = retResponse.copyWith(data: data);
        }
        return Future.value(retResponse);
      } else {
        if (response?.body?.isNotEmpty ?? false) {
          final data = JsonMapper.deserialize<TError>(response.body);
          retResponse = retResponse.copyWith(errorData: data);
        }
        return Future.error(retResponse);
      }
    } catch (e) {
      retResponse = retResponse.copyWith(errorMessage: e.toString());
      return Future.error(retResponse);
    }
  }

  String createBearerToken(String token) {
    return 'Bearer $token';
  }

  ApiResponse<TData, TError> _defaultResponse<TData, TError>(
      TData data, Response response,
      {String message = '', TError error}) {
    return _defaultResponseBase<TData, TError>(
        data, response.statusCode, response.contentLength, response.headers,
        errorData: error, message: message);
  }

  ApiResponse<TData, TError> _defaultResponseBase<TData, TError>(TData data,
      int statusCode, int contentLength, Map<String, String> headers,
      {String message = '', TError errorData}) {
    return ApiResponse<TData, TError>(
      statusCode: statusCode,
      contentLength: contentLength ?? 0,
      errorData: errorData,
      data: data,
      errorMessage: message,
      headers: MapUtils.toCaseInsensitive(headers),
    );
  }

  String get baseUrl => _environment.baseUrl;
  Uri get parsedBaseUri => _environment.parsedBaseUrl;
  String get basePath => _environment.parsedBaseUrl.path == '/'
      ? ''
      : _environment.parsedBaseUrl.path;

  static String getUrl(String relativeUrl, String baseUrl) {
    return '${!UrlUtils.isAbsoluteUrl(relativeUrl) ? baseUrl : ''}$relativeUrl';
  }

  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer ',
      'User-Agent': getUserAgent(),
      'Device-Id': _deviceConfig.deviceId,
      'Device-Type': getDeviceType(),
      'Content-Type': 'application/json'
    };
  }

  String getDeviceForm() {
    return deviceSize != null && !AppUtils.isWeb
        ? ScreenUtils.getDeviceForm(
            ScreenUtils.isSmallScreenByWidth(deviceSize.shortestSide))
        : ScreenUtils.getDeviceForm();
  }

  String get userAgent => getUserAgent(getDeviceForm());

  static String getDeviceType([String deviceForm]) {
    return '${AppUtils.platformName}:${deviceForm ?? ScreenUtils.getDeviceForm()}';
  }

  static String getUserAgent([String deviceForm]) {
    return 'BBIDevice:${deviceForm ?? ScreenUtils.getDeviceForm()}:${AppUtils.appName}'
        ':${AppUtils.appVersion}:${AppUtils.platformName}:${AppUtils.deviceInfo.version}';
  }

  static bool isSuccess(Response response) {
    return isSuccessCode(response.statusCode);
  }

  static bool isSuccessCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  void dispose() {}
}
