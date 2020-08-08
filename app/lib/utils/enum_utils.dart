import 'dart:math';

import 'string_utils.dart';

class EnumUtils {
  static String enumToString<T>(T enumVal,
      [bool sentenceCase = false, String nullText]) {
    if (enumVal == null) {
      return nullText ?? 'null';
    }
    final value = enumVal.toString().split('.').last;
    return sentenceCase ? StringUtils.toSentenceCase(value) : value;
  }

  static T enumFromString<T>(List<T> enumValues, String value,
      [bool ignoreCase = false]) {
    if (value == null) {
      return null;
    }
    if (ignoreCase) value = value.toLowerCase();
    final String typeName = enumValues[0]?.toString()?.split('.')[0];
    return enumValues.firstWhere((T e) {
      var enumValue = e.toString();
      if (ignoreCase) enumValue = enumValue.toLowerCase();
      return enumValue ==
          '${ignoreCase ? typeName.toLowerCase() : typeName}.$value';
    }, orElse: () => null);
  }

  static String enumToStringWithPad<T>(List<T> enumValues, T enumVal,
      [bool sentenceCase = false]) {
    final longestValLen = enumValues
        .map((val) => enumToString(enumVal, sentenceCase).length)
        .reduce(max);
    return StringUtils.rightPad(
        enumToString(enumVal, sentenceCase), longestValLen);
  }
}
