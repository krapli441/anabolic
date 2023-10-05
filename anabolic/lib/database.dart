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

Future<void> insertExercise(Map<String, String> exerciseData) async {
  // 데이터베이스 초기화
  final db = await initializeDB();

  // 삽입할 데이터 준비
  Map<String, dynamic> dataToInsert = {
    "name": exerciseData["exercise"],
    "weight": int.parse(exerciseData["weight"] ?? "0"),
    "reps": int.parse(exerciseData["reps"] ?? "0"),
    "sets": int.parse(exerciseData["sets"] ?? "0"),
    "notes": exerciseData["notes"],
    "date": exerciseData["date"],
  };

  // 데이터 삽입
  await db.insert("Exercise", dataToInsert);

  // 삽입 성공 여부 확인
  if (dataToInsert != 0) {
    print("운동 기록이 데이터베이스에 성공적으로 삽입되었습니다. ID: $dataToInsert");
  } else {
    print("운동 기록 삽입에 실패했습니다.");
  }
}

Future<List<Map<String, dynamic>>> fetchExerciseByDate(String date) async {
  final db = await initializeDB(); // 데이터베이스 초기화
  final List<Map<String, dynamic>> maps = await db.query(
    'Exercise',
    where: 'date = ?',
    whereArgs: [date],
  );
  return maps;
}

Future<void> deleteExercise(Map<String, dynamic> exerciseData) async {
  final db = await initializeDB(); // 데이터베이스 초기화

  if (exerciseData.values.any((value) => value == null)) {
    print('One or more fields are null');
    return;
  }

  await db.delete(
    'Exercise',
    where:
        'name = ? AND weight = ? AND reps = ? AND sets = ? AND notes = ? AND date = ?',
    whereArgs: [
      exerciseData['name'],
      exerciseData['weight'],
      exerciseData['reps'],
      exerciseData['sets'],
      exerciseData['notes'],
      exerciseData['date']
    ],
  );
}
