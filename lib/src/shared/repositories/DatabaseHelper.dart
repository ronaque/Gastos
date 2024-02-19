import 'package:flutter/foundation.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/tag_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gastos/globals.dart' as globals;

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
    // return await openDatabase(path, version: 1, onCreate: _createDatabase);
    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
        version: 4,
        onCreate: (db, version) async {
          var batch = db.batch();
          // We create all the tables
          _createTagsTableV3(batch);
          _createGastosTableV3(batch);
          await batch.commit();
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          var batch = db.batch();
          if (oldVersion < 4) {
            _updateGastosV1toV2(batch);
            await batch.commit();
          }
        }));
  }

  // Método para criar a tabela no banco de dados
  Future<void> _createDatabase(Database db, int version) async {
    await _createTagsTable(db);
    await _createGastosTable(db);
    await inicializarTagsPadroes();
  }

  // Método para inserir uma nova tag no banco de dados
  // Método para criar a tabela 'tags' no banco de dados
  Future<void> _createTagsTable(Database db) async {
    await db.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        nome TEXT
      )
    ''');
  }

  void _createTagsTableV3(Batch batch) async {
    batch.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        nome TEXT
      )
    ''');
  }

  // Método para criar a tabela 'gastos' no banco de dados
  Future<void> _createGastosTable(Database db) async {
    await db.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY,
        data TEXT,
        quantidade REAL,
        tag_id INTEGER,
        descricao TEXT,
        FOREIGN KEY(tag_id) REFERENCES tags(id)
      )
      ''');
  }

  void _createGastosTableV3(Batch batch) async {
    batch.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY,
        data TEXT,
        quantidade REAL,
        tag_id INTEGER,
        descricao TEXT,
        mode INTEGER,
        parcelas INTEGER,
        FOREIGN KEY(tag_id) REFERENCES tags(id)
      )
      ''');
  }

  Future<void> inicializarTagsPadroes() async{
    globals.tagsPadroes.forEach((key, value) async {
      Tag tag = await novaTag(key);
      Database? db = await database;
      await db?.insert('tags', tag.toMap());
    });
  }

  void _updateGastosV1toV2(Batch batch) {
    batch.execute('ALTER TABLE gastos ADD COLUMN mode INTEGER');
    batch.execute('ALTER TABLE gastos ADD COLUMN parcelas INTEGER');
  }
}
