import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toFormattedString() => DateFormat('HH:mm').format(this);
}