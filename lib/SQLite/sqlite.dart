import 'package:sqflite/sqflite.dart';
import 'package:studystack/core/model/deck.dart';
import 'package:studystack/core/model/users.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String databaseName = "studystack.db";
   Future<Database> get db async{
    return initDB();
  }

  String deckTable = "CREATE TABLE Decks ("
      "deckId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "userId INTEGER NOT NULL, "
      "title TEXT NOT NULL, "
      "FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE)";


  String users = "CREATE TABLE Users ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
      "email TEXT NOT NULL, "
      "password TEXT NOT NULL)";

  Future<Database> initDB() async { 
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName); //databasePath/studystack.db

    return openDatabase(path, version: 8, onCreate: (db, version) async {
      await db.execute(users); 
      await db.execute(deckTable); 
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 4) {
         
      }
    });
  }



  // CRUD Operations




  // Create Deck (insert)
    Future<int> createDeck(Decks deck) async {
    var dbc = await db;
    return dbc.insert('Decks', deck.toJson());
  }




  // Delete Deck
  Future<int> deleteDeck(int id) async {
    var dbc = await db;
    int result = await dbc.delete('Decks', where: 'deckId = ?', whereArgs: [id]);
    print("Delete result: $result");
    return result;
  }

  // Update Deck
  Future<int> updateDeck(String title, int deckId) async {
    var dbc = await db;
    return dbc.rawUpdate(
        'UPDATE Decks SET title = ? WHERE deckId = ?', [title, deckId]);
  }

  // Read Decks for a specific user
  Future<List<Decks>> getDecks(int userId) async {
    var dbc = await db;
    List<Map<String, Object?>> result = await dbc.query(
      "Decks",
      where: "id = ?",
      whereArgs: [userId],
    );
    return result.map((e) => Decks.fromJson(e)).toList();
  }

  // Search Decks for a specific user
  Future<List<Decks>> searchDecks(String keyword, int userId) async {
    var dbc = await db;
    List<Map<String, Object?>> searchResult = await dbc.rawQuery(
        "SELECT * FROM Decks WHERE title LIKE ? AND id = ?",
        ['%$keyword%', userId]);
    return searchResult.map((e) => Decks.fromJson(e)).toList();
  }

  // User login
  Future<bool> login(Users user) async {
    var dbc = await db;
    var result = await dbc.query(" select * from Users where email= ${user.email} AND ${user.password}"
    );
    if(result == true){
      return true; 
    }else{
      return false; 
    }
  }

  // User sign-up
  Future<int> signUp(Users user) async {
    var dbc = await db;
    return dbc.insert('Users', user.toJson());
  }
}