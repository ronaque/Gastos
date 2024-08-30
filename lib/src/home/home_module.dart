import 'package:gastos/src/shared/date_utils.dart';

String getMonth() {
  DateTime now = DateTime.now();
  return getMonthName(now.month);
}
