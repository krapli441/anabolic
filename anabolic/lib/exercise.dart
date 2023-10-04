import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // 간격 조정
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(5),
              padding: const EdgeInsets.all(6),
              dashPattern: const [8, 4],
              color: Colors.blue,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0), // 그림자 제거
                    minimumSize: MaterialStateProperty.all(const Size(350, 70)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExerciseRecord(),
                      ),
                    );
                  },
                  child: const Text(
                    '운동 추가하기',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            )
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
