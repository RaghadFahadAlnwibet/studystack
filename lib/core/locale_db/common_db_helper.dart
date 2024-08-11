import 'package:sqflite/sqflite.dart';
import 'package:studystack/core/locale_db/sql_constant_key.dart';

class CommonDBHelper {
  static createTables(Database db) {
    db.execute(
      '${SqlKey.deckTable}',
    );

    db.execute(
      '${SqlKey.users}',
    );


  }
}