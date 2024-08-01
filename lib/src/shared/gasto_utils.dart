import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/repositories/TagHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

Future<Gasto> createGasto(DateTime data, double quantidade, Tag tag,
    String descricao, int mode, int parcelas) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('gasto_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('gasto_id', id);
  return Gasto(
      id: id,
      data: data,
      quantidade: quantidade,
      tag: tag,
      descricao: descricao,
      mode: mode,
      parcelas: parcelas);
}

Future<void> insertGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.insertGasto(gasto);
}

Future<void> removeGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.removeGasto(gasto);
}

Future<void> removeGastoById(int id) async {
  GastoHelper gastoHelper = GastoHelper();
  gastoHelper.removeGastoById(id);
}

Future<bool> updateGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  return gastoHelper.updateGasto(gasto);
}

Future<List<Gasto>> getAllGastos() async {
  GastoHelper gastoHelper = GastoHelper();
  return gastoHelper.getAllGastos();
}

Future<List<Gasto>> getGastosByTagName(String tagName) async {
  GastoHelper gastoHelper = GastoHelper();
  TagHelper tagHelper = TagHelper();
  Tag? tag = await tagHelper.getTagByNome(tagName);
  if (tag == null) {
    return [];
  }

  return gastoHelper.getGastosByTagName(tagName);
}

Future<List<Gasto>> getGastosByTagId(int tagId) async {
  GastoHelper gastoHelper = GastoHelper();
  TagHelper tagHelper = TagHelper();
  Tag? tag = await tagHelper.getTagById(tagId);
  if (tag == null) {
    return [];
  }

  return gastoHelper.getGastosByTagId(tagId);
}

Future<List<Gasto>> getGastosByMonth(DateTime data) async {
  GastoHelper gastoHelper = GastoHelper();

  String year = DateFormat('y').format(data);
  String month = DateFormat('MM').format(data);

  return gastoHelper.getGastosByMonth(year, month);
}

Future<List<Gasto>> getGastosByMonthAndPositiveExpense(DateTime data) {
  GastoHelper gastoHelper = GastoHelper();

  String year = DateFormat('y').format(data);
  String month = DateFormat('MM').format(data);

  return gastoHelper.getGastosByMonthAndPositiveExpense(year, month);
}

Future<List<Gasto>> getGastosByMonthAndNegativeExpense(DateTime data) {
  GastoHelper gastoHelper = GastoHelper();

  String year = DateFormat('y').format(data);
  String month = DateFormat('MM').format(data);

  return gastoHelper.getGastosByMonthAndNegativeExpense(year, month);
}

Future<List<Gasto>> getParcelasGasto(Gasto gasto) async {
  GastoHelper gastoHelper = GastoHelper();
  List<Gasto> listParcelasGastos = [gasto];
  Gasto? actualGasto = gasto;
  while (true) {
    DateTime date = actualGasto!.data;
    int parcelas = actualGasto.parcelas! + 1;
    int year = date.year;
    int month = date.month + 1;
    if (month > 12) {
      month = month - 12;
      year += 1;
    }
    date = DateTime(year, month, 1);

    actualGasto = await gastoHelper.getGastoByCriteria(
        data: date,
        tagId: gasto.tag.id,
        descricao: gasto.descricao!,
        quantidade: gasto.quantidade,
        parcelas: parcelas);
    if (actualGasto == null) {
      break;
    } else {
      listParcelasGastos.add(actualGasto);
    }
  }

  return listParcelasGastos;
}
