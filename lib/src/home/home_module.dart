import 'package:gastos/src/shared/data_utils.dart';

String getMonth() {
  DateTime now = DateTime.now();
  return getMonthName(now.month);
}



