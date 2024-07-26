import 'package:gastos/src/shared/gasto_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
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
  List<Gasto> gastos = await listarGastosDoMes(data);
  double gastosTotal = 0;
  for (int i = 0; i < gastos.length; i++) {
    gastosTotal += gastos[i].quantidade;
  }

  double? saldo = await getSaldo();

  return saldo + gastosTotal;
}

Future<void> atualizarSaldoNovoMes() async{
  TagHelper tagHelper = TagHelper();

  final prefs = await SharedPreferences.getInstance();

  String? ultimoLogin = prefs.getString('ultimo_login');

  if (ultimoLogin == null) {
    prefs.setString('ultimo_login', DateTime.now().toString());
    return;
  }

  double saldo = 0;

  DateTime ultimoLoginDate = DateTime.parse(ultimoLogin);
  DateTime now = DateTime.now();

  if (now.month != ultimoLoginDate.month) {
    // Recuperar gastos do mes de ultimo login
    List<Gasto> ultimoLoginGastos = await listarGastosDoMes(ultimoLoginDate);
    // Somar valores totais dos gastos
    for (int i = 0; i < ultimoLoginGastos.length; i++) {
      saldo += ultimoLoginGastos[i].quantidade;
    }

    // Adicionar um novo pagamento ao mês atual com o valor total dos gastos
    Tag? tag = await tagHelper.getTagByNome('gasto');
    if (tag != null) {
      inserirGasto(await novoGasto(DateTime(now.year, now.month, 1), saldo, tag, "Saldo", 0, 0));
    }
  }

  prefs.setString('ultimo_login', now.toString());

  return;
}