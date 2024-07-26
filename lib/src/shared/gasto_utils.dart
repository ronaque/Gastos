import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<Gasto> novoGasto(DateTime data, double quantidade, Tag tag, String descricao, int mode, int parcelas) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('gasto_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('gasto_id', id);
  return Gasto(id: id, data: data, quantidade: quantidade, tag: tag, descricao: descricao, mode: mode, parcelas: parcelas);
}

Future<List<Gasto>> listarParcelasGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  List<Gasto> listaParcelasGastos = [gasto];
  Gasto? gastoAtual = gasto;
  while (true) {
    DateTime data = gastoAtual!.data;
    int parcelas = gastoAtual.parcelas! + 1;
    int ano = data.year;
    int mes = data.month + 1;
    if (mes > 12){
      mes = mes - 12;
      ano += 1;
    }
    data = DateTime(ano, mes, 1);

    gastoAtual = await gastoHelper.getGastosByDataAndTagAndDescricaoAndQuantidadeAndParcelas(DateFormat('y').format(data), DateFormat('MM').format(data),
        DateFormat('dd').format(data), gasto.tag.id!, gasto.descricao!, gasto.quantidade, parcelas);
    if (gastoAtual == null) {
      break;
    } else {
      listaParcelasGastos.add(gastoAtual);
    }
  }

  return listaParcelasGastos;
}