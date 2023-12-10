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
}