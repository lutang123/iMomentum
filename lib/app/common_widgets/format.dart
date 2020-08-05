import 'package:intl/intl.dart';

class Format {
  static String hours(double hours) {
    final hoursNotNegative = hours == null ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String minutes(double minutes) {
    final displayedDuration = minutes == null
        ? 0.0
        : minutes < 60
            ? minutes //e.g. displayedDuration = 40
            : double.parse((minutes / 60)
                .toStringAsFixed(2)); // e.g. displayedDuration = 1.2
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(displayedDuration);
    return minutes == null
        ? '0 minute'
        : minutes < 60 ? '$formatted minutes' : '$formatted hours';
  }

  static String date(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  static String time(DateTime date) {
    return DateFormat('kk:mm').format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
