import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  static int? toJsonInt(DateTime? date) {
    return date?.microsecondsSinceEpoch;
  }

  static DateTime? fromJsonInt(int? json) {
    if (json == null) return null;

    return DateTime.fromMicrosecondsSinceEpoch(json);
  }

  static DateTime? fromString(String? date) {
    if (date == null) return null;

    return DateTime.tryParse(date);
  }

  String getDate() {
    return DateFormat('h:mm a').format(this);
  }

  String getDateString() {
    return DateFormat.yMd().format(this);
  }
}
