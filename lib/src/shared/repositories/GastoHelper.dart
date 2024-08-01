import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gastos/src/shared/models/Gasto.dart';

class GastoHelper {
  Future<Database> get database async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Se o banco de dados ainda não existe, inicialize-o
    Database db = await dbHelper.database;
    return db;
  }

  // Método para inserir um novo gasto no banco de dados
  Future<void> insertGasto(Gasto gasto) async {
    Database db = await database;
    await db.insert('gastos', gasto.toMap());
  }

  // Método para obter todos os gastos do banco de dados
  Future<List<Gasto>> getAllGastos() async {
    Database db = await database;
    List<Map<String, Object?>>? maps = await db.query('gastos');
    return List.generate(maps.length, (i) {
      return Gasto.fromMap(maps[i]);
    });
  }

  Future<List<Gasto>> getGastosByTagName(String tag) async {
    Database db = await database;

    final List<Map<String, Object?>> result = await db.rawQuery('''
    SELECT gastos.id, gastos.data, gastos.quantidade, gastos.descricao, gastos.mode, gastos.parcelas, tags.nome as tag_nome, 
    FROM gastos
    INNER JOIN tags ON gastos.tag_id = tags.id
    WHERE tags.nome = ?
  ''', [tag]);

    return List.generate(result.length, (i) {
      return Gasto.fromMap(result[i]);
    });
  }

  Future<List<Gasto>> getGastosByTagId(int tagId) async {
    Database db = await database;

    final List<Map<String, Object?>> resultado = await db.rawQuery('''
    SELECT gastos.id, gastos.data, gastos.quantidade, gastos.descricao, gastos.mode, gastos.parcelas, tags.nome as tag_nome
    FROM gastos
    INNER JOIN tags ON gastos.tag_id = tags.id
    WHERE gastos.tag_id = ?
  ''', [tagId]);

    return List.generate(resultado.length, (i) {
      return Gasto.fromMap(resultado[i]);
    });
  }

  Future<List<Gasto>> getGastosByMonth(String ano, String mes) async {
    Database db = await database;

    String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        INNER JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ?
      ''';

    final List<Map<String, Object?>> result =
        await db.rawQuery(query, [ano, mes]);

    return List.generate(result.length, (i) {
      return Gasto.fromMap(result[i]);
    });
  }

  Future<List<Gasto>> getGastosByMonthAndPositiveExpense(
      String ano, String mes) async {
    try {
      Database db = await database;

      String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        LEFT JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ? AND gastos.quantidade >= 0
      ''';

      List<Map<String, Object?>>? resultado =
          await db.rawQuery(query, [ano, mes]);

      return List.generate(resultado.length, (i) {
        return Gasto.fromMap(resultado[i]);
      });
    } catch (e) {
      print('Erro ao obter gastos do mês com quantidade positiva: $e');
      return [];
    }
  }

  Future<List<Gasto>> getGastosByMonthAndNegativeExpense(
      String ano, String mes) async {
    try {
      Database db = await database;

      String query = '''
        SELECT gastos.*, tags.id as tag_id, tags.nome as tag_nome
        FROM gastos
        LEFT JOIN tags ON gastos.tag_id = tags.id
        WHERE strftime('%Y', gastos.data) = ? AND strftime('%m', gastos.data) = ? AND gastos.quantidade < 0
      ''';

      List<Map<String, Object?>>? resultado =
          await db.rawQuery(query, [ano, mes]);

      return List.generate(resultado.length, (i) {
        return Gasto.fromMap(resultado[i]);
      });
    } catch (e) {
      print('Erro ao obter gastos do mês com quantidade negativa: $e');
      return [];
    }
  }

  Future<List<Gasto>> getGastosListByCriteria({
    required DateTime data,
    required int tagId,
    String? descricao,
    double? quantidade,
    int? parcelas,
  }) async {
    try {
      Database db = await database;

      String query = '''
      SELECT gastos.id, gastos.data, gastos.quantidade, gastos.descricao, gastos.mode, gastos.parcelas, tags.id as tag_id, tags.nome as tag_nome
      FROM gastos
      LEFT JOIN tags ON gastos.tag_id = tags.id
      WHERE gastos.data = ? AND gastos.tag_id = ?
      ${descricao != null ? 'AND gastos.descricao = ?' : ''}
      ${quantidade != null ? 'AND gastos.quantidade = ?' : ''}
      ${parcelas != null ? 'AND gastos.parcelas = ?' : ''}
    ''';

      final List<Map<String, Object?>> resultado = await db.rawQuery(query, [
        data.toIso8601String(),
        tagId,
        if (descricao != null) descricao,
        if (quantidade != null) quantidade,
        if (parcelas != null) parcelas,
      ]);

      return List.generate(resultado.length, (i) {
        return Gasto.fromMap(resultado[i]);
      });
    } catch (e) {
      print('Erro ao obter gastos por critérios: $e');
      return [];
    }
  }

  Future<Gasto?> getGastoByCriteria({
    required DateTime data,
    required int tagId,
    String? descricao,
    double? quantidade,
    int? parcelas,
  }) async {
    try {
      Database db = await database;

      // Construir a consulta SQL dinamicamente com base nos parâmetros fornecidos
      String query = '''
      SELECT gastos.id, gastos.data, gastos.quantidade, gastos.descricao, gastos.mode, gastos.parcelas, tags.id as tag_id, tags.nome as tag_nome
      FROM gastos
      LEFT JOIN tags ON gastos.tag_id = tags.id
      WHERE gastos.data = ? AND gastos.tag_id = ?
      ${descricao != null ? 'AND gastos.descricao = ?' : ''}
      ${quantidade != null ? 'AND gastos.quantidade = ?' : ''}
      ${parcelas != null ? 'AND gastos.parcelas = ?' : ''}
      LIMIT 1
    ''';

      final List<Map<String, Object?>> resultado = await db.rawQuery(query, [
        data.toIso8601String(),
        tagId,
        if (descricao != null) descricao,
        if (quantidade != null) quantidade,
        if (parcelas != null) parcelas,
      ]);

      // Retorna o primeiro resultado encontrado, ou null se não houver resultados
      if (resultado.isNotEmpty) {
        return Gasto.fromMap(resultado.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar gasto por critérios: $e');
      return null;
    }
  }

  Future<bool> updateGasto(Gasto gasto) async {
    try {
      Database db = await database;

      await db.update(
        'gastos',
        gasto
            .toMap(), // Utiliza o método toMap() da classe Gasto para obter um Map com os valores atualizados
        where: 'id = ?',
        whereArgs: [gasto.id],
      );
      return true;
    } catch (e) {
      print('Erro ao atualizar gasto: $e');
      return false;
    }
  }

  Future<void> removeGasto(Gasto gasto) async {
    try {
      Database db = await database;

      await db.delete(
        'gastos',
        where: 'id = ?',
        whereArgs: [gasto.id],
      );
    } catch (e) {
      print('Erro ao remover gasto: $e');
    }
  }

  Future<void> removeGastoById(int gastoId) async {
    try {
      Database db = await database;

      await db.delete(
        'gastos',
        where: 'id = ?',
        whereArgs: [gastoId],
      );
    } catch (e) {
      print('Erro ao remover gasto por ID: $e');
    }
  }
}
