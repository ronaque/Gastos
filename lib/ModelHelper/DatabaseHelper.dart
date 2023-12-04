import 'package:gastos/Model/Gasto.dart';
import 'package:gastos/Model/Tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _db;

  // Método para obter a instância do banco de dados
  Future<Database?> get database async {
    if (_db != null) return _db;

    // Se o banco de dados ainda não existe, inicialize-o
    _db = await initDatabase();
    return _db;
  }

  // Método para inicializar o banco de dados
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'tags_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Método para criar a tabela no banco de dados
  Future<void> _createDatabase(Database db, int version) async {
    await _createTagsTable(db);
    await _createGastosTable(db);
  }

  // Método para inserir uma nova tag no banco de dados
  // Método para criar a tabela 'tags' no banco de dados
  Future<void> _createTagsTable(Database db) async {
    await db.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  // Método para criar a tabela 'gastos' no banco de dados
  Future<void> _createGastosTable(Database db) async {
    await db.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY,
        date TEXT,
        quantity INTEGER,
        tag_id INTEGER,
        FOREIGN KEY(tag_id) REFERENCES tags(id)
      )
      ''');
  }

  // Método para inserir uma nova tag no banco de dados
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
    SELECT gastos.id, gastos.date, gastos.quantity, tags.name as tag_name
    FROM gastos
    INNER JOIN tags ON gastos.tag_id = tags.id
    WHERE tags.name = ?
  ''', [tagName]);

    return List.generate(result!.length, (i) {
      return Gasto.fromMap(result[i]);
    });
  }

  // Função para excluir uma tag com base no nome
  Future<void> deleteTagByName(String tagName) async {
    Database? db = await database;

    // Obtém o ID da tag com base no nome
    List<Map<String, Object?>>? tagResult = await db?.query('tags', where: 'name = ?', whereArgs: [tagName]);
    if (tagResult!.isNotEmpty) {
      Object? tagId = tagResult.first['id'];

      // Exclui a tag da tabela 'tags'
      await db?.delete('tags', where: 'id = ?', whereArgs: [tagId]);

      // Também é recomendável excluir os gastos associados à tag
      await db?.delete('gastos', where: 'tag_id = ?', whereArgs: [tagId]);
    }
  }
}
