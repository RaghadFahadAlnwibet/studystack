import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:studystack/core/locale_db/sql_constant_key.dart';

import '../../feature/decks/model/deck.dart';
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

  }


















  


