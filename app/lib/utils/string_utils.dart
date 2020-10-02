import 'package:flutter/widgets.dart';

import 'number_utils.dart';

const unicode_superscript_map = <String, String>{
  '0': '\u2070',
  '1': '\u00B9',
  '2': '\u00B2',
  '3': '\u00B3',
  '4': '\u2074',
  '5': '\u2075',
  '6': '\u2076',
  '7': '\u2077',
  '8': '\u2078',
  '9': '\u2079',
  'a': '\u1d43',
  'b': '\u1d47',
  'c': '\u1d9c',
  'd': '\u1d48',
  'e': '\u1d49',
  'f': '\u1da0',
  'g': '\u1d4d',
  'h': '\u02b0',
  'i': '\u2071',
  'j': '\u02b2',
  'k': '\u1d4f',
  'l': '\u02e1',
  'm': '\u1d50',
  'n': '\u207f',
  'o': '\u1d52',
  'p': '\u1d56',
  'q': '?',
  'r': '\u02b3',
  's': '\u02e2',
  't': '\u1d57',
  'u': '\u1d58',
  'v': '\u1d5b',
  'w': '\u02b7',
  'x': '\u02e3',
  'y': '\u02b8',
  'z': '?',
  'A': '\u1d2c',
  'B': '\u1d2e',
  'C': '?',
  'D': '\u1d30',
  'E': '\u1d31',
  'F': '?',
  'G': '\u1d33',
  'H': '\u1d34',
  'I': '\u1d35',
  'J': '\u1d36',
  'K': '\u1d37',
  'L': '\u1d38',
  'M': '\u1d39',
  'N': '\u1d3a',
  'O': '\u1d3c',
  'P': '\u1d3e',
  'Q': '?',
  'R': '\u1d3f',
  'S': '?',
  'T': '\u1d40',
  'U': '\u1d41',
  'V': '\u2c7d',
  'W': '\u1d42',
  'X': '?',
  'Y': '?',
  'Z': '?',
  '+': '\u207A',
  '-': '\u207B',
  '=': '\u207C',
  '(': '\u207D',
  ')': '\u207E',
  ':alpha': '\u1d45',
  ':beta': '\u1d5d',
  ':gamma': '\u1d5e',
  ':delta': '\u1d5f',
  ':epsilon': '\u1d4b',
  ':theta': '\u1dbf',
  ':iota': '\u1da5',
  ':pho': '?',
  ':phi': '\u1db2',
  ':psi': '\u1d60',
  ':chi': '\u1d61',
  ':coffee': '\u2615',
};

class StringUtils {
  static bool isNullOrEmpty(String text, [bool checkWhiteSpace = false]) {
    return text == null || (checkWhiteSpace ? text.trim() : text) == '';
  }

  static String capitalize(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  // TODO(shah): Placeholder implementation.
  static String pluralize(String text) {
    return '$text${!isPlural(text) ? 's' : ''}';
  }

  // TODO(shah): Placeholder implementation.
  static bool isPlural(String text) {
    return text.endsWith('s');
  }

  static String toSentenceCase(String text) {
    return capitalize(text.replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])(?!([A-Z]|$))'), (m) => ' ${m[1]}'));
  }

  static String removeAtIndex(String text, int index, [int count = 1]) {
    return text.substring(0, index) + text.substring(index + count);
  }

  static String ensureEndsWith(String text, String endStr) {
    return text + (text.endsWith(endStr) ? '' : endStr);
  }

  static String repeat(String text, int count) {
    return text * count;
  }

  static String rightPad(String text, int length,
      [String padChar = '', bool trimToLength = false]) {
    return text.length >= length
        ? trimToLength ? text.substring(0, length) : text
        : text + repeat(padChar, length - text.length);
  }

  static String mask(String text, int length,
      {TextDirection maskDirection = TextDirection.rtl,
      String maskChar = '*',
      int maskCharCount = 3}) {
    final maskEnd = maskDirection == TextDirection.rtl;
    length = NumberUtils.restrictMax(length, text.length);
    maskCharCount =
        NumberUtils.restrictMax(maskCharCount, text.length - length);
    return (maskEnd ? maskChar * maskCharCount : '') +
        text.substring(maskEnd ? text.length - length : 0,
            maskEnd ? text.length : length) +
        (!maskEnd ? maskChar * maskCharCount : '');
  }

  static String getInitials(String text) {
    return RegExp('(?<![A-Z]|\$)([A-Z])')
        .allMatches(text)
        .map((m) => m.group(0))
        .join('');
  }

  static String stripNonDigits(String text) {
    return text.replaceAll(RegExp(r'\D+'), '');
  }

  static String restrictLength(String text, int maxLength,
      [String truncateIndicatorText = '...']) {
    return text.length > maxLength
        ? text.substring(0, maxLength) + truncateIndicatorText
        : text;
  }

  static String getSupercript(String text) {
    return text.split('').map((c) => unicode_superscript_map[c]).join('');
  }
}
