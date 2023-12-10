import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gastos/src/shared/models/Gasto.dart';

class GastoHelper{
  Database? _db;
  DatabaseHelper db = DatabaseHelper();

  Future<Database?> get database async {
    if (_db != null) return _db;

    // Se o banco de dados ainda não existe, inicialize-o
    _db = await db.initDatabase();
    return _db;
  }

  // Método para inserir um novo gasto no banco de dados
  Future<void> insertGasto(Gasto gasto) async {
    Database? db = await database;
    await db?.insert('gastos', gasto.toMap());
  }

  // Método para obter todos os gastos do banco de dados
  Future<List<Gasto>> getAllGastos() async {
    Database? db = await database;
    List<Map<String, Object?>>? maps = await db?.query('gastos');
    return List.generate(maps!.length, (i) {
      return Gasto.fromMap(maps[i]);
    });
  }

  Future<List<Gasto>> getGastosByTagName(String tagName) async {
    Database? db = await database;

    final List<Map<String, Object?>>? result = await db?.rawQuery('''
    SELECT gastos.id, gastos.data, gastos.quantidade, tags.nome as tag_nome
    FROM gastos
    INNER JOIN tags ON gastos.tag_id = tags.id
    WHERE tags.nome = ?
  ''', [tagName]);

    return List.generate(result!.length, (i) {
      return Gasto.fromMap(result[i]);
    });
  }
}