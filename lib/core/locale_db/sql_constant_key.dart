class SqlKey{
  static const String databaseName = "studystack.db";





  static const String deckTable = "CREATE TABLE Decks("
      "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
      "userId INTEGER NOT NULL,"
      "title TEXT NOT NULL,"
      "FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE CASCADE"
      ")";

  static const String users = "CREATE TABLE Users("
      "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
      "email TEXT NOT NULL,"
      "password TEXT NOT NULL)";


}