import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Future<Database> initializeDB() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + '/exercise.db';
  return openDatabase(
    path,
    version: 2,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE Exercise(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, notes TEXT, weight INTEGER, sets INTEGER, reps INTEGER, date TEXT)",
      );
      await db.execute(
          "CREATE TABLE IF NOT EXISTS CompletedExerciseDates(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, exercise_ids TEXT)");
    },
  );
}

Future<void> insertExercise(Map<String, String> exerciseData) async {
  // 데이터베이스 초기화
  final db = await initializeDB();

  // 삽입할 데이터 준비
  Map<String, dynamic> dataToInsert = {
    "name": exerciseData["name"],
    "weight": int.parse(exerciseData["weight"] ?? "0"),
    "reps": int.parse(exerciseData["reps"] ?? "0"),
    "sets": int.parse(exerciseData["sets"] ?? "0"),
    "notes": exerciseData["notes"],
    "date": exerciseData["date"],
  };

  // 데이터 삽입
  await db.insert("Exercise", dataToInsert);
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
  try {
    final db = await initializeDB(); // 데이터베이스 초기화

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
        exerciseData['date'],
      ],
    );
  } catch (e) {
    // print("데이터 삭제 중 오류가 발생했습니다 :  $e");
  }
}

Future<void> updateExercise(
    Map<String, dynamic> updatedData, Map<String, dynamic> originalData) async {
  try {
    final db = await initializeDB();

    // Update the record
    int updateCount = await db.update(
      'Exercise',
      updatedData,
      where:
          'name = ? AND weight = ? AND reps = ? AND sets = ? AND notes = ? AND date = ?',
      whereArgs: [
        originalData['name'],
        originalData['weight'],
        originalData['reps'],
        originalData['sets'],
        originalData['notes'],
        originalData['date'],
      ],
    );
    // print("Updated Count: $updateCount");

    // 업데이트된 행의 수 확인
    if (updateCount == 1) {
      // print("Update successful");
    } else {
      // print('Update failed:$updateCount');
    }
  } catch (e) {
    // print("업데이트 중 오류가 발생했습니다: $e");
  }
}

Future<void> clearExerciseTable() async {
  final db = await initializeDB();
  await db.execute("DELETE FROM Exercise");
  await db.execute("DELETE FROM CompletedExerciseDates");
}

// 특정 날짜의 운동 기록을 가져오는 함수
Future<List<Map<String, dynamic>>> getExerciseRecordsByDate(
    Database db, String formattedDate) async {
  try {
    final List<Map<String, dynamic>> result = await db.query(
      'Exercise',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
    return result;
  } catch (e) {
    // print("날짜별 운동 기록을 가져오는 중 오류가 발생했습니다: $e");
    return [];
  }
}

// 운동 종료 기록을 데이터베이스에 추가하는 함수
Future<int?> insertCompletedExerciseDate(
    Database db, Map<String, dynamic> data) async {
  try {
    final int result = await db.insert('CompletedExerciseDates', data);
    return result;
  } catch (e) {
    // print("운동 종료 날짜를 데이터베이스에 추가하는 중 오류가 발생했습니다: $e");
    return null;
  }
}

Future<List<Map<String, dynamic>>> fetchCompletedExercises() async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> maps =
      await db.query('CompletedExerciseDates');
  return maps;
}

Future<List<Map<String, dynamic>>> fetchExerciseDataForDate(
    DateTime date) async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'CompletedExerciseDates',
    where: 'date = ?',
    whereArgs: [
      date.toIso8601String().split('T').first
    ], // 'YYYY-MM-DD' 형태로 날짜를 문자열로 변환
  );
  return maps;
}

Future<List<Map<String, dynamic>>> fetchExercisesByIds(List<int> ids) async {
  final db = await initializeDB();

  // ID 목록을 쉼표로 구분된 문자열로 변환
  String idList = ids.join(',');

  // IN 연산자를 사용하여 여러 ID에 일치하는 레코드를 조회
  final List<Map<String, dynamic>> maps =
      await db.rawQuery('SELECT * FROM Exercise WHERE id IN ($idList)');

  return maps;
}

Future<List<Map<String, dynamic>>> fetchExercisesByDate(DateTime date) async {
  final db = await initializeDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'Exercise',
    where: 'date = ?',
    whereArgs: [date.toIso8601String()],
  );
  return maps;
}

// 특정 날짜의 '운동 종료' 기록을 삭제하는 함수
Future<void> deleteCompletedExerciseDate(
    Database db, String formattedDate) async {
  try {
    await db.delete(
      'CompletedExerciseDates', // 운동 종료 기록을 저장하는 테이블 이름
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
  } catch (e) {
    // print("운동 종료 기록을 삭제하는 중 오류가 발생했습니다: $e");
  }
}
