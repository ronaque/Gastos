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
    SELECT gastos.id, gastos.data, gastos.quantidade, gastos.descricao, gastos.mode, gastos.parcelas, tags.nome as tag_nome, 
    FROM gastos
    INNER JOIN tags ON gastos.tag_id = tags.id
    WHERE tags.nome = ?
  ''', [tagName]);

    return List.generate(result!.length, (i) {
      return Gasto.fromMap(result[i]);
    });
  }

  Future<List<Gasto>?> getGastosByTagId(int tagId) async {
    Database? db = await database;

    List<Map<String, Object?>>? result = await db?.query(
      'gastos',
      where: 'tag_id = ?',
      whereArgs: [tagId],
    );

    List<Gasto>? gastos = result?.map((map) => Gasto.fromMap(map)).toList();

    return gastos;
  }

  Future<List<Gasto>?> getGastosDoMes(String ano, String mes) async {
    Database? db = await database;

    String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        INNER JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ?
      ''';

    List<Map<String, Object?>>? result = await db?.rawQuery(query, [ano, mes]);

    List<Gasto>? gastos = await result?.map((map) => Gasto.fromMap(map)).toList();

    return gastos;
  }

  Future<List<Gasto>?> getGastosDoMesComQuantidadePositiva(String ano, String mes) async {
    try {
      Database? db = await database;

      String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        LEFT JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ? AND gastos.quantidade >= 0
      ''';

      List<Map<String, Object?>>? result = await db?.rawQuery(query, [ano, mes]);

      if (result == null || result.isEmpty) {
        return null;
      }

      List<Gasto>? gastos = result.map((map) => Gasto.fromMap(map)).toList();

      return gastos;
    } catch (e) {
      print('Erro ao obter gastos do mês com quantidade positiva: $e');
      return null;
    }
  }

  Future<List<Gasto>?> getGastosDoMesComQuantidadeNegativa(String ano, String mes) async {
    try {
      Database? db = await database;

      String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        LEFT JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ? AND gastos.quantidade < 0
      ''';

      List<Map<String, Object?>>? result = await db?.rawQuery(query, [ano, mes]);

      if (result == null || result.isEmpty) {
        return null;
      }

      List<Gasto>? gastos = result.map((map) => Gasto.fromMap(map)).toList();

      return gastos;
    } catch (e) {
      print('Erro ao obter gastos do mês com quantidade negativa: $e');
      return null;
    }
  }

  Future<Gasto?> getGastosByDataAndTagAndDescricaoAndQuantidadeAndParcelas(String ano, String mes, String dia, int tagId, String descricao, double quantidade, int parcelas) async {
    Database? db = await database;

    List<Map<String, Object?>>? result = await db?.query(
      'gastos',
      where: 'strftime("%Y", data) = ? AND strftime("%m", data) = ? AND strftime("%d", data) = ? AND tag_id = ? AND descricao = ? AND quantidade = ? AND parcelas = ?',
      whereArgs: [ano, mes, dia, tagId, descricao, quantidade, parcelas],
    );

    if (result == null || result.isEmpty) {
      return null;
    }

    return Gasto.fromMap(result[0]);
  }

  Future<bool> atualizarGasto(Gasto gasto) async {
    try {
      Database? db = await database;

      await db?.update(
        'gastos',
        gasto.toMap(), // Utiliza o método toMap() da classe Gasto para obter um Map com os valores atualizados
        where: 'id = ?',
        whereArgs: [gasto.id],
      );
      return true;
    } catch (e) {
      print('Erro ao atualizar gasto: $e');
      return false;
    }
  }

  Future<void> removerGastoPorId(int gastoId) async {
    try {
      Database? db = await database;

      await db?.delete(
        'gastos',
        where: 'id = ?',
        whereArgs: [gastoId],
      );
    } catch (e) {
      print('Erro ao remover gasto por ID: $e');
    }
  }

}