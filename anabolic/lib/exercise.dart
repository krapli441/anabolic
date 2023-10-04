import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

class ExerciseList extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseList({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.85;

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
                      minimumSize: MaterialStateProperty.all(Size(width, 70)),
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.blue), // plus 아이콘 추가
                        SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
                        Text(
                          '운동 추가하기',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ExerciseRecord extends StatefulWidget {
  const ExerciseRecord({Key? key}) : super(key: key);

  @override
  _ExerciseRecordState createState() => _ExerciseRecordState();
}

class _ExerciseRecordState extends State<ExerciseRecord> {
  TextEditingController exerciseController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: exerciseController,
                decoration: const InputDecoration(labelText: '운동 이름'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration:
                    const InputDecoration(labelText: '중량', suffixText: 'kg'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: repsController,
                decoration:
                    const InputDecoration(labelText: '횟수', suffixText: '회'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: setsController,
                decoration:
                    const InputDecoration(labelText: '세트', suffixText: '세트'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: '특이사항'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0), // 그림자 제거
                  minimumSize: MaterialStateProperty.all(Size(width, 70)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  // 여기서 상태에 입력된 정보를 저장할 수 있습니다.
                  // 예를 들어, List나 Map에 저장할 수 있습니다.
                  // 이후에 ExerciseList 페이지로 돌아갑니다.
                  Navigator.pop(context);
                },
                child: const Text('추가하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
