import 'package:flutter/material.dart';

class ExerciseList extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseList({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('운동 기록'),
            const SizedBox(height: 20), // 간격 조정
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseRecord(),
                  ),
                );
              },
              child: const Text('운동 추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseRecord extends StatelessWidget {
  const ExerciseRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기록'),
      ),
      body: const Center(
        child: Text('여기서 운동을 기록할 수 있습니다.'),
      ),
    );
  }
}
