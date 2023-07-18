import 'package:intl/intl.dart';

class TimelineUtils {
  static String formatDatetime(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);

  static String formatDate(DateTime dateTime) =>
      DateFormat("yyyy-MM-dd").format(dateTime);

  static String formatYear(DateTime dateTime) =>
      DateFormat("yyyy").format(dateTime);

  static String formatDay(DateTime dateTime) =>
      DateFormat("MM-dd").format(dateTime);

  static String formatTime(DateTime dateTime) =>
      DateFormat("HH:mm").format(dateTime);

  static bool isMonthFirstDay(DateTime dateTime){
    return dateTime.day == 1;
  }
}

