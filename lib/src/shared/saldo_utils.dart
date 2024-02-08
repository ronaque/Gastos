import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<void> atualizarSaldo(double value) async {
  final prefs = await SharedPreferences.getInstance();

  double? saldo = prefs.getDouble('saldo');

  if (saldo == null) {
    prefs.setDouble('saldo', value);
    return;
  }

  saldo += value;

  prefs.setDouble('saldo', saldo);
  return;
}

Future<double> getSaldo() async{
  final prefs = await SharedPreferences.getInstance();

  double? saldo = prefs.getDouble('saldo');

  if (saldo == null) {
    prefs.setDouble('saldo', 0);
    return 0;
  }

  return saldo;
}

Future<double> getSaldoByMonth(DateTime data) async {
  GastoHelper gastoHelper = GastoHelper();

  List<Gasto>? gastos = await gastoHelper.getGastosDoMes(DateFormat('y').format(data), DateFormat('MM').format(data));
  double gastosTotal = 0;
  if (gastos != null) {
    for (int i = 0; i < gastos.length; i++) {
      gastosTotal += gastos[i].quantidade!;
    }
  }

  double? saldo = await getSaldo();

  return saldo + gastosTotal;
}

Future<void> atualizarSaldoNovoMes() async{
  final prefs = await SharedPreferences.getInstance();

  String? ultimo_login = prefs.getString('ultimo_login');

  if (ultimo_login == null) {
    prefs.setString('ultimo_login', DateTime.now().toString());
    return;
  }

  double? saldo = await getSaldo();

  DateTime ultimoLoginDate = DateTime.parse(ultimo_login);
  DateTime now = DateTime.now();

  if (now.month != ultimoLoginDate.month) {
    double? salario = prefs.getDouble('salario')!;
    saldo += salario;
  }

  prefs.setDouble('saldo', saldo);
  prefs.setString('ultimo_login', now.toString());

  return;
}