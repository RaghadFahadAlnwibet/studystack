import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:studystack/core/locale_db/sql_constant_key.dart';



import '../model/deck.dart';
import 'common_db_helper.dart';


class DBHelper {
  static Database? dataBase;

  static Future<void> initDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    dataBase = await sql.openDatabase(
      path.join(dbPath, SqlKey.databaseName),
      onCreate: (db, version) => CommonDBHelper.createTables(db),
      version: 1,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(
      {required String tableName}) async {
    return await dataBase!.query(tableName);
  }

  static Future<int> insert(
      {required String table, required Map<String, dynamic> data}) async {
    return await dataBase!.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(String table, int id, data) async {
    return await dataBase!.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> delete(String table, {int? id}) async {
    return await dataBase!.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  static Future<int> updateDeck(String title, int deckId) async {
    return dataBase!.rawUpdate(
        'UPDATE Decks SET title = ? WHERE deckId = ?', [title, deckId]);
  }

  // Read Decks for a specific user
  static Future<List<Decks>> getDecks(int userId) async {
    List<Map<String, Object?>> result = await dataBase!.query(
      "Decks",
      where: "id = ?",
      whereArgs: [userId],
    );
    return result.map((e) => Decks.fromJson(e)).toList();
  }

  // Search Decks for a specific user
  static Future<List<Decks>> searchDecks(String keyword, int userId) async {
    List<Map<String, Object?>> searchResult = await dataBase!.rawQuery(
        "SELECT * FROM Decks WHERE title LIKE ? AND id = ?",
        ['%$keyword%', userId]);
    return searchResult.map((e) => Decks.fromJson(e)).toList();
  }

  // Create Deck (insert)
  static Future<int> createDeck(Decks deck) async {
    return dataBase!.insert('Decks', deck.toJson());
  }




  // Delete Deck
  static Future<int> deleteDeck(int id) async {
    int result = await dataBase!.delete('Decks', where: 'deckId = ?', whereArgs: [id]);
    print("Delete result: $result");
    return result;
  }


}