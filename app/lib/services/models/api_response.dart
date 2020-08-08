import 'package:arrahma_mobile_app/utils/models/key_value_pair.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
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
  final List<KeyValuePair<String, String>> fieldErrors;

  final int contentLength;
  final Map<String, String> headers;

  ApiResponse<TOut, TError> copyWith(
      {int statusCode,
      TOut data,
      TError errorData,
      String errorMessage,
      List<KeyValuePair<String, String>> fieldErrors,
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
