import 'package:studystack/feature/decks/repository/i_decks_repository.dart';
import 'package:studystack/core/locale_db/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studystack/feature/decks/model/deck.dart';

class DecksRepository extends IDecksRepository{

  @override
  Future<int> insert({required String table, required Map<String, dynamic> data}) async{
      return await DBHelper.dataBase!.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }


  @override
  Future<int> delete(String table, int id) async{
    return await DBHelper.dataBase!.delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );
  }

  @override
  Future<List<Decks>> searchDecks(String keyword, int userId) async{
    List<Map<String, Object?>> searchResult = await DBHelper.dataBase!.rawQuery(
          "SELECT * FROM Decks WHERE title LIKE ? AND id = ?",
          ['%$keyword%', userId]);
      return searchResult.map((e) => Decks.fromJson(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getData(int id) async{
    return await DBHelper.dataBase!.rawQuery(
    "SELECT * FROM Decks WHERE userId = ?",
      [id],
     );
  }

  @override
  Future<int> update(int id, data) async{
      return await DBHelper.dataBase!.update(
        'Decks',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );

  }

}


// delete, update // search 