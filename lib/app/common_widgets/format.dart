import 'package:intl/intl.dart';

class Format {
  static String hours(double hours) {
    final hoursNotNegative = hours == null ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String minutes(double minutes) {
    final minutesNotNegative = minutes == 0 ? 0.0 : minutes;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(minutesNotNegative);
    return '${formatted}minutes';
  }

  static String date(DateTime date) {
    return DateFormat.MMMd().format(date);
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
