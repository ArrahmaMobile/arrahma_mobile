import 'dart:math';

class NumberUtils {
  static double getAverage<T extends num>(List<T> nums) {
    return nums.fold<num>(0, (a, b) => a + b) / nums.length;
  }

  static String formatBytes(int bytes, [int decimals = 2]) {
    if ((bytes ?? 0) <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static T restrictMax<T extends num>(T val, T maxVal) {
    return maxVal == null ? val : val > maxVal ? maxVal : val;
  }

  static String toCurrency(double amount,
      [int precision = 2, bool showPositive = false]) {
    return '${amount.isNegative ? '-' : amount != 0 && showPositive ? '+' : ''}\$${amount.abs().toStringAsFixed(precision)}';
  }

  static String formatNumber(String amount) {
    return amount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  static String formatCurrency(double amount,
      {int precision = 2, bool showPositive = false}) {
    return formatNumber(toCurrency(amount, precision, showPositive));
  }

  static String formatPercentage(double value, [int precision = 2]) {
    return '${(value * 100).toStringAsFixed(precision)}%';
  }
}
