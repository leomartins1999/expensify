import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String format() => formatter.format(this);
}

DateFormat formatter = DateFormat("dd/MM/yyyy");
