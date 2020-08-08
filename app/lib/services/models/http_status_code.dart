import 'package:arrahma_mobile_app/utils/bi_map.dart';

enum HttpStatus {
  ClientClosedRequest,
  ServiceUnavailable,
  GatewayTimeout,
  ServerUnreachable,
  TimeoutError,
  LocalProcessingException,
  NoDeviceConnection,
  DuplicateRequest,
}

final httpStatusCodeMap = BiMap<HttpStatus, int>()
  ..addAll({
    HttpStatus.ClientClosedRequest: 499,
    HttpStatus.ServiceUnavailable: 503,
    HttpStatus.GatewayTimeout: 504,
    HttpStatus.ServerUnreachable: 523,
    HttpStatus.TimeoutError: 524,
    HttpStatus.LocalProcessingException: 602,
    HttpStatus.NoDeviceConnection: 603,
    HttpStatus.DuplicateRequest: 666
  });
