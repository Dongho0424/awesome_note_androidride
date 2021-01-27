import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future database() async {
    final String databasePath = await getDatabasesPath();

    return openDatabase(join(databasePath, 'notes_database.db'),
        onCreate: (database, version) {
      return database.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, imagePath TEXT)');
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getNotesFromDB() async {
    final Database database = await DatabaseHelper.database();
    print("## database: $database");
    return database.query("notes", orderBy: "id DESC");
  }

  static Future insert(Map<String, Object> data) async {
    final Database database = await DatabaseHelper.database();
    print("## database: $database");
    // to update, when conflict prior data, replace it with the new one.
    database.insert("notes", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future delete(int id) async {
    final Database database = await DatabaseHelper.database();
    print("## database: $database");
    return database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
