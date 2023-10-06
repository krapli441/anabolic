// main.dart
// package
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

// components
import 'exercise_day_select.dart';
import 'database.dart';
import 'exercise_calendar.dart';

Future<void> main() async {
  runApp(const MyApp());
  await initializeDB();
}

class MyApp extends StatelessWidget {
  final bool showSnackBar;

  const MyApp({this.showSnackBar = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showSnackBar) {
      Future.delayed(
        Duration.zero,
        () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('운동을 성공적으로 저장했습니다.')),
        ),
      );
    }

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR') // 한국어 설정
      ],
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Icon(
                  Icons.fitness_center_sharp,
                  color: Colors.white,
                  size: 100,
                )),
              ),
              const SizedBox(height: 15),
              Text('ANABOLIC',
                  style: GoogleFonts.stalinistOne(
                    fontSize: 32,
                    color: Colors.blue,
                  )),
              const SizedBox(height: 30),
              const ExerciseRecordButton(),
              const SizedBox(height: 20),
              const ExerciseCalenderButton(),
              const SizedBox(height: 20),
              const DatabaseResetButton(),
            ],
          ),
        ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class ExerciseRecordButton extends StatelessWidget {
  const ExerciseRecordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExerciseDaySelector()));
        },
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(200, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center),
            SizedBox(
              width: 10,
            ),
            Text('운동 기록'),
          ],
        ));
  }
}

class ExerciseCalenderButton extends StatelessWidget {
  const ExerciseCalenderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExerciseCalendar()));
        },
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(200, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book),
            SizedBox(
              width: 10,
            ),
            Text('일지 확인'),
          ],
        ));
  }
}

class DatabaseResetButton extends StatelessWidget {
  const DatabaseResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          // 데이터베이스에 운동 기록 추가
          await clearExerciseTable();
          // ignore: use_build_context_synchronously
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(200, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete),
            SizedBox(
              width: 10,
            ),
            Text('데이터베이스 지우기'),
          ],
        ));
  }
}
