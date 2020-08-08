class DurationUtils {
  static String durationToString(Duration duration) {
    String twoDigits(num n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes = twoDigits(duration?.inMinutes?.remainder(60) ?? 0);
    final twoDigitSeconds = twoDigits(duration?.inSeconds?.remainder(60) ?? 0);
    return '${twoDigits(duration?.inHours ?? 0)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
