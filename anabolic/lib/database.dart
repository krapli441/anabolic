import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Future<Database> initializeDB() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + '/exercise.db';
  return openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE Exercise(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, notes TEXT, weight INTEGER, sets INTEGER, reps INTEGER, date TEXT)",
      );
    },
  );
}
