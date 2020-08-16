import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class JsonApiResponse {
  const JsonApiResponse({
    this.errorData,
    this.errorMessage,
    this.fieldErrors,
    this.data,
  });

  final dynamic data;
  final dynamic errorData;
  final String errorMessage;
  final List<FieldKeyValuePair> fieldErrors;
}

class FieldKeyValuePair {
  const FieldKeyValuePair({this.key, this.value});
  final String key;
  final String value;
}

class ApiResponse<TOut, TError> {
  const ApiResponse(
      {this.statusCode,
      this.data,
      this.errorData,
      this.errorMessage,
      this.fieldErrors,
      this.contentLength,
      this.headers});
  final int statusCode;
  final TOut data;
  final TError errorData;

  final String errorMessage;
  final List<FieldKeyValuePair> fieldErrors;

  final int contentLength;
  final Map<String, String> headers;

  ApiResponse<TOut, TError> copyWith(
      {int statusCode,
      TOut data,
      TError errorData,
      String errorMessage,
      List<FieldKeyValuePair> fieldErrors,
      int contentLength,
      Map<String, String> headers}) {
    return ApiResponse<TOut, TError>(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      errorData: errorData ?? this.errorData,
      errorMessage: errorMessage ?? this.errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      contentLength: contentLength ?? this.contentLength,
      headers: headers ?? this.headers,
    );
  }

  @JsonProperty(ignore: true)
  bool get isSuccess =>
      statusCode != null &&
      statusCode >= 200 &&
      statusCode < 300 &&
      errorData == null;
}
