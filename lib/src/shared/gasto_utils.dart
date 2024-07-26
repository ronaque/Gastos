import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
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

Future<void> inserirGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.inserirGasto(gasto);
}

Future<void> removerGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.removerGasto(gasto);
}

Future<void> removerGastoPorId(int id) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.removerGastoPorId(id);
}

Future<bool> atualizarGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  return gastoHelper.atualizarGasto(gasto);
}

Future<List<Gasto>> listarTodosGastos() async {
  GastoHelper gastoHelper = GastoHelper();
  return gastoHelper.listarTodosGastos();
}

Future<List<Gasto>> listarGastosPorNomeTag(String tagName) async {
  GastoHelper gastoHelper = GastoHelper();
  TagHelper tagHelper = TagHelper();
  Tag? tag = await tagHelper.getTagByNome(tagName);
  if (tag == null) {
    return [];
  }

  return gastoHelper.listarGastosPorNomeDaTag(tagName);
}

Future<List<Gasto>> listarGastosPorIdDaTag(int tagId) async {
  GastoHelper gastoHelper = GastoHelper();
  TagHelper tagHelper = TagHelper();
  Tag? tag = await tagHelper.getTagById(tagId);
  if (tag == null) {
    return [];
  }

  return gastoHelper.listarGastosPorIdDaTag(tagId);
}

Future<List<Gasto>> listarGastosDoMes(DateTime data) async {
  GastoHelper gastoHelper = GastoHelper();

  String ano = DateFormat('y').format(data);
  String mes = DateFormat('MM').format(data);

  return gastoHelper.listarGastosDoMes(ano, mes);
}

Future<List<Gasto>> listarGastosDoMesComQuantidadePositiva(DateTime data) {
  GastoHelper gastoHelper = GastoHelper();

  String ano = DateFormat('y').format(data);
  String mes = DateFormat('MM').format(data);

  return gastoHelper.listarGastosDoMesComQuantidadePositiva(ano, mes);
}

Future<List<Gasto>> listarGastosDoMesComQuantidadeNegativa(DateTime data) {
  GastoHelper gastoHelper = GastoHelper();

  String ano = DateFormat('y').format(data);
  String mes = DateFormat('MM').format(data);

  return gastoHelper.listarGastosDoMesComQuantidadeNegativa(ano, mes);
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

    gastoAtual = await gastoHelper.buscarGastoPorCriterios(data: data, tagId: gasto.tag.id!, descricao: gasto.descricao!, quantidade: gasto.quantidade, parcelas: parcelas);
    if (gastoAtual == null) {
      break;
    } else {
      listaParcelasGastos.add(gastoAtual);
    }
  }

  return listaParcelasGastos;
}