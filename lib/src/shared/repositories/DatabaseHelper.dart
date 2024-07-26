import 'package:flutter/foundation.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/tag_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gastos/globals.dart' as globals;

class DatabaseHelper {
  // Método para obter a instância do banco de dados
  Future<Database> get database async {
    Database db = await _initDatabase();
    return db;
  }

  // Método para inicializar o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');
    return await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
        version: 4,
        onCreate: (db, version) async {
          await _createTagsTable(db);
          await _createGastosTable(db);
          await inicializarTagsPadroes();
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          var batch = db.batch();
          if (oldVersion < 4) {
            _updateGastosV1toV2(batch);
            await batch.commit();
          }
        }));
  }

  Future<void> _createTagsTable(Database db) async {
    await db.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY,
        nome TEXT
      )
    ''');
  }

  Future<void> _createGastosTable(Database db) async {
    await db.execute('''
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
      await db.insert('tags', tag.toMap());
    });
  }

  void _updateGastosV1toV2(Batch batch) {
    batch.execute('ALTER TABLE gastos ADD COLUMN mode INTEGER');
    batch.execute('ALTER TABLE gastos ADD COLUMN parcelas INTEGER');
  }
}
