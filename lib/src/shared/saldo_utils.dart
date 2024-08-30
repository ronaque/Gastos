import 'package:gastos/src/shared/gasto_utils.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/tag_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBalance(double value) async {
  final prefs = await SharedPreferences.getInstance();

  double? balance = prefs.getDouble('saldo');

  if (balance == null) {
    prefs.setDouble('saldo', value);
    return;
  }

  balance += value;

  prefs.setDouble('saldo', balance);
  return;
}

Future<double> fetchBalance() async {
  final prefs = await SharedPreferences.getInstance();

  double? balance = prefs.getDouble('saldo');

  if (balance == null) {
    prefs.setDouble('saldo', 0);
    return 0;
  }

  return balance;
}

Future<double> getMonthBalance(DateTime data) async {
  List<Gasto> gastos = await getGastosByMonth(data);
  double gastosTotal = 0;
  for (int i = 0; i < gastos.length; i++) {
    gastosTotal += gastos[i].quantidade;
  }

  double? balance = await fetchBalance();

  return balance + gastosTotal;
}

Future<void> updateNewMonthBalance() async {
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
    List<Gasto> ultimoLoginGastos = await getGastosByMonth(ultimoLoginDate);
    // Somar valores totais dos gastos
    for (int i = 0; i < ultimoLoginGastos.length; i++) {
      saldo += ultimoLoginGastos[i].quantidade;
    }

    // Adicionar um novo pagamento ao mês atual com o valor total dos gastos
    Tag? tag = await getTagByNome('gasto');
    if (tag != null) {
      insertGasto(await createGasto(
          DateTime(now.year, now.month, 1), saldo, tag, "Saldo", 0, 0));
    } else {
      print("Tag 'gasto' não encontrada");
      Tag gastoTag = await createTag('gasto');
      await insertTag(gastoTag);
    }
  }

  prefs.setString('ultimo_login', now.toString());

  print("ultimo login atualizado para: ${prefs.getString('ultimo_login')}");
  return;
}
