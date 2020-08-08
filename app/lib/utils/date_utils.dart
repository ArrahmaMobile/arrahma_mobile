import 'dart:io';

import 'package:intl/intl.dart';

import 'string_utils.dart';

enum DayOfWeek {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday
}

class DateUtils {
  static DateTime parseHttpDate(String date) {
    return HttpDate.parse(date);
  }

  static String formatHttpDate(DateTime date) {
    return HttpDate.format(date);
  }

  static String formatReadableDate(DateTime date,
      {bool showAt = false, bool showSeconds = true}) {
    return DateFormat(
            'MMMM d, y ${showAt ? "'at' " : ''}h:mm${showSeconds ? ':ss' : ''} a')
        .format(date.toLocal());
  }

  static String formatReadableMonth(DateTime date) {
    return DateFormat('MMMM yyyy').format(date.toLocal());
  }

  // static const _lookupMessagesMap = <String, LookupMessages>{
  //   'en': EnMessages(),
  //   'en_short': EnShortMessages(),
  // };

  // static String formatReadableRelativeTime(DateTime date,
  //     {String locale, DateTime clock, bool allowFromNow}) {
  //   final _locale = locale ?? 'en';
  //   final _allowFromNow = allowFromNow ?? false;
  //   final messages = _lookupMessagesMap[_locale] ?? const EnMessages();
  //   final _clock = clock ?? DateTime.now();
  //   var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

  //   String prefix, suffix;

  //   if (_allowFromNow && elapsed < 0) {
  //     elapsed = date.isBefore(_clock) ? elapsed : elapsed.abs();
  //     prefix = messages.prefixFromNow();
  //     suffix = messages.suffixFromNow();
  //   } else {
  //     prefix = messages.prefixAgo();
  //     suffix = messages.suffixAgo();
  //   }

  //   final num seconds = elapsed / 1000;
  //   final num minutes = seconds / 60;
  //   final num hours = minutes / 60;
  //   final num days = hours / 24;
  //   final num months = days / 30;
  //   final num years = days / 365;

  //   String result;
  //   if (seconds < 45) {
  //     result = messages.lessThanOneMinute(seconds.round());
  //   } else if (seconds < 90) {
  //     result = messages.aboutAMinute(minutes.round());
  //   } else if (minutes < 45) {
  //     result = messages.minutes(minutes.round());
  //   } else if (minutes < 90) {
  //     result = messages.aboutAnHour(minutes.round());
  //   } else if (hours < 24) {
  //     result = messages.hours(hours.round());
  //   } else if (hours < 48) {
  //     result = messages.aDay(hours.round());
  //   } else if (days < 30) {
  //     result = messages.days(days.round());
  //   } else if (days < 60) {
  //     result = messages.aboutAMonth(days.round());
  //   } else if (days < 365) {
  //     result = messages.months(months.round());
  //   } else if (years < 2) {
  //     result = messages.aboutAYear(months.round());
  //   } else {
  //     result = messages.years(years.round());
  //   }

  //   return [prefix, result, suffix]
  //       .where((str) => str != null && str.isNotEmpty)
  //       .join(messages.wordSeparator());
  // }

  static String formatReadableContextDate(DateTime date,
      {bool useDaySuffix = false, bool showPrefix = true}) {
    if (date == null) return 'N/A';
    date = date.toLocal();
    final now = DateTime.now();
    String prefix;
    if (isSameDay(date))
      prefix = 'Today';
    else if (isSameDay(date, now.subtract(const Duration(days: 1))))
      prefix = 'Yesterday';
    else if (isSameDay(date, now.add(const Duration(days: 1))))
      prefix = 'Tomorrow';
    else /*if (date.isAfter(now) && date.difference(now).inDays < 7)*/
      prefix = DateFormat.EEEE().format(date);
    // if (date.isBefore(now) && date.difference(now).inDays > -7)
    //   return 'Last ${DateFormat.EEEE().format(date)}';
    final sameYear = date.year == now.year;
    return '${showPrefix && prefix != null ? '$prefix, ' : ''}' +
        DateFormat(
                'MMM d${useDaySuffix ? "'${getDayOfMonthSuffix(date.day)}'" : ''}${sameYear ? '' : ', yyyy'}')
            .format(date.toLocal());
  }

  static bool isSameDay(DateTime date, [DateTime other]) {
    date = date.toLocal();
    other = other?.toLocal() ?? DateTime.now();
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  static DateTime trimToDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime trimToMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static String formatReadableOnlyDate(DateTime date,
      [bool useDaySuffix = false]) {
    return DateFormat('EEEE, MMMM d').format(date.toLocal()) +
        (useDaySuffix ? getDayOfMonthSuffix(date.day) : '');
  }

  static String formatReadableFixedLengthTime(DateTime date) {
    return DateFormat('hh:mm:ss a').format(date.toLocal());
  }

  static String formatShortDate(DateTime date) {
    return date != null ? DateFormat('M/d/yy h:ma').format(date) : null;
  }

  static String formatOnlyDate(DateTime date) {
    return date != null ? DateFormat('MM/dd/yyyy').format(date) : null;
  }

  static DateTime getNextDayOfWeek(DayOfWeek dayOfWeek, [DateTime date]) {
    date ??= DateTime.now();
    return date.subtract(Duration(days: date.weekday - (dayOfWeek.index + 1)));
  }

  static String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  static String getDayOfMonthSuffix(int dayNum, [bool useSuperscript = true]) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return useSuperscript ? StringUtils.getSupercript('th') : 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return useSuperscript ? StringUtils.getSupercript('st') : 'st';
      case 2:
        return useSuperscript ? StringUtils.getSupercript('nd') : 'nd';
      case 3:
        return useSuperscript ? StringUtils.getSupercript('rd') : 'rd';
      default:
        return useSuperscript ? StringUtils.getSupercript('th') : 'th';
    }
  }
}
