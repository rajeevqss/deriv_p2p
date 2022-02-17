import 'package:intl/intl.dart';

class TimeUtil {
  static final TimeUtil _singleton = TimeUtil._internal();

  static DateFormat inputTimeFormat = DateFormat("HH:mm:ss");
  DateFormat outputTimeFormat24 = DateFormat("H:mm");
  DateFormat outputTimeFormat12 = DateFormat("h:mm a");
  static DateFormat inputDateFormat = DateFormat("MM/dd/yyyy");
  static DateFormat inputLogDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  static DateFormat outputLogDateFormat = DateFormat("yyyy-MM-dd");
  static DateFormat graphDateFormat = DateFormat("dd-MM-yyyy");

  static DateFormat outputLogHistoryDateFormat = DateFormat("MMM dd, yyyy");

  factory TimeUtil() {
    return _singleton;
  }

  TimeUtil._internal();

  String? formatTimeString(String time) {
    try {
      DateTime dateTime = inputTimeFormat.parse(time);
      return outputTimeFormat24.format(dateTime);
    } catch (_) {
      return null;
    }
  }

  String? formatLogDate(String date) {
    try {
      DateTime dateTime = inputDateFormat.parse(date);
      return inputLogDateFormat.format(dateTime);
    } catch (_) {
      return null;
    }
  }

    String? formatDateTime(DateTime dateTime, DateFormat inputFormat) {
    try {
      return inputFormat.format(dateTime);
    } catch (_) {
      return null;
    }
  }

  getTimeFromSeconds(int seconds) {
    Duration d = Duration(seconds: seconds);
    return d
        .toString()
        .split('.')
        .first
        .padLeft(8, "0");
  }

  String? formatDate(String date, DateFormat inputFormat,
      DateFormat outputFormat) {
    try {
      DateTime dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String? getTodayFormatDate(DateFormat outputFormat) {
    try {
      DateTime dateTime = DateTime.now();
      return outputFormat.format(dateTime);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
