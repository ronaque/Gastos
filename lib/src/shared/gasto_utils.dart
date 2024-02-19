import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<Gasto> novoGasto(DateTime data, double quantidade, Tag? tag, String descricao, int mode, int parcelas) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('gasto_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('gasto_id', id);
  return Gasto(id, data, quantidade, tag, descricao, mode, parcelas);
}

Future<List<Gasto>> listarParcelasGastos(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  List<Gasto> lista_parcelas_gastos = [gasto];
  Gasto? gasto_atual = gasto;
  while (true) {
    DateTime data = gasto_atual!.data!;
    int parcelas = gasto_atual.parcelas! + 1;
    int year = data.year;
    int month = data.month + 1;
    if (month > 12){
      month = month - 12;
      year += 1;
    }
    data = DateTime(year, month, 1);

    gasto_atual = await gastoHelper.getGastosByDataAndTagAndDescricaoAndQuantidadeAndParcelas(DateFormat('y').format(data), DateFormat('MM').format(data),
        DateFormat('dd').format(data), gasto.tag!.id!, gasto.descricao!, gasto.quantidade!, parcelas);
    if (gasto_atual == null) {
      break;
    } else {
      lista_parcelas_gastos.add(gasto_atual);
    }
    // break;
  }

  return lista_parcelas_gastos;
}