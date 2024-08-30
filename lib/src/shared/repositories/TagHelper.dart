import 'package:gastos/globals.dart';
import 'package:gastos/src/shared/repositories/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gastos/src/shared/models/Tag.dart';

class TagHelper {
  Future<Database> get database async {
    DatabaseHelper dbHelper = DatabaseHelper();

    Database db = await dbHelper.database;
    return db;
  }

  Future<void> insertTag(Tag tag) async {
    Database? db = await database;
    await db.insert('tags', tag.toMap());
  }

  Future<List<Tag>> getAllTags() async {
    Database db = await database;
    List<Map<String, Object?>>? maps = await db.query('tags');
    return List.generate(maps.length, (i) {
      return Tag.fromMap(maps[i]);
    });
  }

  Future<List<Tag>> getCustomTags() async {
    List<String> defaultTags = tagsPadroes.keys.toList();
    Database? db = await database;

    String defaultTagsPlaceholders = defaultTags.map((e) => '?').join(', ');

    List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT * FROM tags WHERE nome NOT IN ($defaultTagsPlaceholders)',
      defaultTags,
    );

    return List.generate(result.length, (i) {
      return Tag.fromMap(result[i]);
    });
  }

  Future<Tag?> getTagByNome(String nome) async {
    Database db = await database;

    List<Map<String, Object?>>? result = await db.query(
      'tags',
      where: 'nome = ?',
      whereArgs: [nome],
      limit:
          1, // Limita a consulta a um resultado, pois esperamos apenas uma tag com o nome específico
    );

    if (result.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null; // Retorna null se não encontrar nenhuma tag com o nome especificado
    }
  }

  Future<Tag?> getTagById(int tagId) async {
    Database db = await database;

    List<Map<String, Object?>>? result = await db.query(
      'tags',
      where: 'id = ?',
      whereArgs: [tagId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> deleteTagByName(String tagName) async {
    Database db = await database;

    List<Map<String, Object?>>? tagResult =
        await db.query('tags', where: 'nome = ?', whereArgs: [tagName]);
    if (tagResult.isNotEmpty) {
      Object? tagId = tagResult.first['id'];

      await db.delete('tags', where: 'id = ?', whereArgs: [tagId]);

      await db.delete('gastos', where: 'tag_id = ?', whereArgs: [tagId]);
    }
  }
}
