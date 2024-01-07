import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Gasto> novoGasto(DateTime data, double quantidade, Tag? tag, String descricao) async {
  final prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('gasto_id');
  if (id == null) {
    id = 0;
  } else {
    id++;
  }
  prefs.setInt('gasto_id', id);
  return Gasto(id, data, quantidade, tag, descricao);
}