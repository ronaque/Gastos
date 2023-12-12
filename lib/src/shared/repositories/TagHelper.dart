import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gastos/src/shared/models/Tag.dart';

class TagHelper{
  Database? _db;
  DatabaseHelper db = DatabaseHelper();

  Future<Database?> get database async {
    if (_db != null) return _db;

    // Se o banco de dados ainda não existe, inicialize-o
    _db = await db.initDatabase();
    return _db;
  }

  Future<void> insertTag(Tag tag) async {
    Database? db = await database;
    await db?.insert('tags', tag.toMap());
  }

  // Método para obter todas as tags do banco de dados
  Future<List<Tag>> getAllTags() async {
    Database? db = await database;
    List<Map<String, Object?>>? maps = await db?.query('tags');
    return List.generate(maps!.length, (i) {
      return Tag.fromMap(maps[i]);
    });
  }

  Future<List<Tag>?> getTagsPersonalizadas() async {
    List<String> exclusoes = tagsPadroes.keys.toList();
    Database? db = await database;

    String exclusoesPlaceholders = exclusoes.map((e) => '?').join(', ');

    List<Map<String, Object?>>? result = await db?.rawQuery(
      'SELECT * FROM tags WHERE nome NOT IN ($exclusoesPlaceholders)',
      exclusoes,
    );

    List<Tag>? tags = result?.map((map) => Tag.fromMap(map)).toList();

    return tags;
  }

  Future<Tag?> getTagByNome(String nome) async {
    Database? db = await database;

    List<Map<String, Object?>>? result = await db?.query(
      'tags',
      where: 'nome = ?',
      whereArgs: [nome],
      limit: 1, // Limita a consulta a um resultado, pois esperamos apenas uma tag com o nome específico
    );

    if (result!.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null; // Retorna null se não encontrar nenhuma tag com o nome especificado
    }
  }

  Future<Tag?> getTagById(int tagId) async {
    Database? db = await database;

    List<Map<String, Object?>>? result = await db?.query(
      'tags',
      where: 'id = ?',
      whereArgs: [tagId],
      limit: 1, // Limita a consulta a um resultado, pois esperamos apenas uma tag com o ID específico
    );

    if (result!.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null; // Retorna null se não encontrar nenhuma tag com o ID especificado
    }
  }

  // Função para excluir uma tag com base no nome
  Future<void> deleteTagByName(String tagName) async {
    Database? db = await database;

    // Obtém o ID da tag com base no nome
    List<Map<String, Object?>>? tagResult = await db?.query('tags', where: 'nome = ?', whereArgs: [tagName]);
    if (tagResult!.isNotEmpty) {
      Object? tagId = tagResult.first['id'];

      // Exclui a tag da tabela 'tags'
      await db?.delete('tags', where: 'id = ?', whereArgs: [tagId]);

      // Também é recomendável excluir os gastos associados à tag
      await db?.delete('gastos', where: 'tag_id = ?', whereArgs: [tagId]);
    }
  }
}