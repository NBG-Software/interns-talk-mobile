import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimeHourMinute(DateTime? dateTime,
      {String defaultValue = 'N/A'}) {
    if (dateTime == null) return defaultValue;
    return DateFormat('h:mm a').format(dateTime);
  }

  static String utcToLocal12Hour(String? utcDate,
      {String defaultValue = 'N/A'}) {
    if (utcDate == null || utcDate.isEmpty) return defaultValue;

    try {
      DateTime utcDateTime = DateTime.parse(utcDate).toUtc();
      DateTime localDateTime = utcDateTime.toLocal();
      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return defaultValue;
    }
  }

  static String formatDate(DateTime? date,
      {String format = 'yyyy-MM-dd', String defaultValue = 'N/A'}) {
    if (date == null) return defaultValue;
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime? date,
      {String format = 'HH:mm:ss', String defaultValue = 'N/A'}) {
    if (date == null) return defaultValue;
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime? date,
      {String format = 'yyyy-MM-dd HH:mm:ss', String defaultValue = 'N/A'}) {
    if (date == null) return defaultValue;
    return DateFormat(format).format(date);
  }

  static String formatToRelative(DateTime? date,
      {String defaultValue = 'N/A'}) {
    if (date == null) return defaultValue;

    final Duration difference = DateTime.now().difference(date);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}
