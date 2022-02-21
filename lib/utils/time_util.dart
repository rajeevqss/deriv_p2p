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

  String? formatDateTime(DateTime dateTime, DateFormat inputFormat) {
    try {
      return inputFormat.format(dateTime);
    } catch (_) {
      return null;
    }
  }
}
