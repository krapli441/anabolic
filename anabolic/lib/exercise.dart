import 'package:anabolic/main.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

// components

import 'database.dart';

class ExerciseList extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseList({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<ExerciseList> {
  List<Map<String, dynamic>> exerciseDataList = [];

  @override
  void initState() {
    super.initState();
    // 날짜를 문자열로 변환.
    String formattedDate =
        "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";
    // 데이터를 불러온다.
    fetchExerciseByDate(formattedDate).then((fetchedData) {
      setState(() {
        exerciseDataList = fetchedData.map((queryRow) {
          return {
            'name': queryRow['name'].toString(),
            'weight': queryRow['weight'].toString(),
            'reps': queryRow['reps'].toString(),
            'sets': queryRow['sets'].toString(),
            'notes': queryRow['notes'].toString(),
            'date': queryRow['date'].toString(),
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일'),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // 간격 조정
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(5),
                  padding: const EdgeInsets.all(6),
                  dashPattern: const [6, 5],
                  color: Colors.blue,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0), // 그림자 제거
                          minimumSize:
                              MaterialStateProperty.all(Size(width, 70)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseRecord(
                                selectedDate: widget.selectedDate, // 날짜를 전달합니다.
                              ),
                            ),
                          );
                          if (result != null) {
                            exerciseDataList.add(result); // 받아온 데이터를 리스트에 추가
                            setState(() {}); // 화면을 갱신
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  child: Column(
                    children: exerciseDataList.map<Widget>((exerciseData) {
                      return GestureDetector(
                        onLongPress: () async {
                          HapticFeedback.lightImpact();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('기록 변경'),
                                  content: const Text('기록을 변경하거나 삭제하시겠어요?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateExerciseRecord(
                                              selectedDate:
                                                  widget.selectedDate, // 날짜 전달.
                                              initialData: exerciseData,
                                            ),
                                          ),
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);

                                        // 기존 데이터를 찾아서 업데이트 (또는 제거)
                                        int index = exerciseDataList.indexWhere(
                                            (element) =>
                                                element == exerciseData);
                                        if (index != -1) {
                                          exerciseDataList[index] = result;
                                        }

                                        if (result != null) {
                                          setState(() {});
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('운동 기록이 변경되었습니다.'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('변경'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final db = await initializeDB();
                                        await deleteExercise(
                                            exerciseData); // 데이터베이스에서 해당 운동을 삭제
                                        // 해당 날짜의 남은 운동 기록을 불러옴
                                        List<Map> remainingExercises =
                                            await getExerciseRecordsByDate(
                                                db, exerciseData['date']);

                                        if (remainingExercises.isEmpty) {
                                          // 모든 운동 기록이 삭제되었으므로, '운동 종료' 데이터도 삭제
                                          await deleteCompletedExerciseDate(
                                              db, exerciseData['date']);
                                        }

                                        setState(
                                          () {
                                            exerciseDataList.removeWhere(
                                                (exercise) =>
                                                    exercise['name'] ==
                                                        exerciseData['name'] &&
                                                    exercise['weight'] ==
                                                        exerciseData[
                                                            'weight'] &&
                                                    exercise['reps'] ==
                                                        exerciseData['reps'] &&
                                                    exercise['sets'] ==
                                                        exerciseData['sets'] &&
                                                    exercise['notes'] ==
                                                        exerciseData['notes'] &&
                                                    exercise['date'] ==
                                                        exerciseData[
                                                            'date']); // UI에서 해당 운동을 삭제
                                          },
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context, 'update');
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('운동 기록이 삭제되었습니다.'),
                                          ),
                                        );
                                      },
                                      child: const Text("삭제"),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: SizedBox(
                            width: width + 10,
                            child: Card(
                                color: Colors.blue,
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //! 좌측 부분
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${exerciseData['name']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.library_books,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${exerciseData['notes']}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      //! 우측 부분
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${exerciseData['weight']}kg',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            '${exerciseData['sets']}세트',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            '${exerciseData['reps']}회',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0), // 그림자 제거
            minimumSize: MaterialStateProperty.all(Size(width, 50)),
            backgroundColor: MaterialStateProperty.all(
              exerciseDataList.isEmpty ? Colors.grey : Colors.blue,
            ),
          ),
          onPressed: exerciseDataList.isEmpty
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('운동 종료'),
                        content: const Text('운동을 종료하시겠어요?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // 0. 데이터베이스 인스턴스를 가져온다.
                              final db = await initializeDB();
                              // 1. 해당 날짜의 모든 운동 기록 ID를 가져온다.
                              String formattedDate =
                                  "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";
                              List<Map> exerciseRecords =
                                  await getExerciseRecordsByDate(
                                      db, formattedDate); // db 인스턴스 추가
                              List<String> exerciseIds = exerciseRecords
                                  .map((record) => record['id'].toString())
                                  .toList();
                              // 2. ID들을 쉼표로 구분된 문자열로 만든다.
                              String exerciseIdsStr = exerciseIds.join(',');
                              // 3. CompletedExerciseDates 테이블에 정보를 저장한다.
                              await insertCompletedExerciseDate(
                                db,
                                {
                                  'date': formattedDate,
                                  'exercise_ids': exerciseIdsStr
                                },
                              );
                              await fetchCompletedExercises();

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                              );
                            },
                            child: const Text('네'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 다이얼로그 닫기
                            },
                            child: const Text('아니요'),
                          ),
                        ],
                      );
                    },
                  );
                },
          child: const Text('운동 종료'),
        ),
      ),
    );
  }
}

class ExerciseRecord extends StatefulWidget {
  final Map<String, String>? initialData;
  final DateTime selectedDate;
  const ExerciseRecord({Key? key, this.initialData, required this.selectedDate})
      : super(key: key);

  @override
  _ExerciseRecordState createState() => _ExerciseRecordState();
}

class _ExerciseRecordState extends State<ExerciseRecord> {
  late TextEditingController exerciseController;
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exerciseController =
        TextEditingController(text: widget.initialData?['exercise'] ?? '');
    weightController =
        TextEditingController(text: widget.initialData?['weight'] ?? '');
    repsController =
        TextEditingController(text: widget.initialData?['reps'] ?? '');
    setsController =
        TextEditingController(text: widget.initialData?['sets'] ?? '');
    notesController =
        TextEditingController(text: widget.initialData?['notes'] ?? '');
    dateController =
        TextEditingController(text: widget.initialData?['date'] ?? '');
  }

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
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            mainAxisSize: MainAxisSize.max, // 가능한 최대로 확장
            children: [
              const SizedBox(height: 50),
              const Text(
                '운동을 기록해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: exerciseController,
                decoration: const InputDecoration(
                    labelText: '운동',
                    border: OutlineInputBorder(), // 테두리 스타일
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0) // 텍스트 필드 안쪽 패딩
                    ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                    labelText: '중량',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(
                    labelText: '횟수',
                    suffixText: '회',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(
                    labelText: '세트',
                    suffixText: '세트',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                    labelText: '특이사항',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0), // 그림자 제거
                  minimumSize: MaterialStateProperty.all(Size(width, 70)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () async {
                  String formattedDate =
                      "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";
                  var exerciseData = {
                    "name": exerciseController.text,
                    "weight": weightController.text,
                    "reps": repsController.text,
                    "sets": setsController.text,
                    "notes": notesController.text,
                    "date": formattedDate
                  };
                  // 데이터베이스에 운동 기록 추가
                  await insertExercise(exerciseData);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, exerciseData);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('운동 기록이 추가되었습니다.'),
                    ),
                  );
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

class UpdateExerciseRecord extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final DateTime selectedDate;
  const UpdateExerciseRecord(
      {Key? key, this.initialData, required this.selectedDate})
      : super(key: key);

  @override
  _ExerciseUpdateState createState() => _ExerciseUpdateState();
}

class _ExerciseUpdateState extends State<UpdateExerciseRecord> {
  late TextEditingController exerciseController;
  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exerciseController =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    weightController =
        TextEditingController(text: widget.initialData?['weight'] ?? '');
    repsController =
        TextEditingController(text: widget.initialData?['reps'] ?? '');
    setsController =
        TextEditingController(text: widget.initialData?['sets'] ?? '');
    notesController =
        TextEditingController(text: widget.initialData?['notes'] ?? '');
    dateController =
        TextEditingController(text: widget.initialData?['date'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            mainAxisSize: MainAxisSize.max, // 가능한 최대로 확장
            children: [
              const SizedBox(height: 50),
              const Text(
                '기록을 수정하세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: exerciseController,
                decoration: const InputDecoration(
                    labelText: '운동',
                    border: OutlineInputBorder(), // 테두리 스타일
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0) // 텍스트 필드 안쪽 패딩
                    ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                    labelText: '중량',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(
                    labelText: '횟수',
                    suffixText: '회',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: setsController,
                decoration: const InputDecoration(
                    labelText: '세트',
                    suffixText: '세트',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                    labelText: '특이사항',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0), // 그림자 제거
                  minimumSize: MaterialStateProperty.all(Size(width, 70)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () async {
                  String formattedDate =
                      "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";
                  var updateData = {
                    "name": exerciseController.text,
                    "weight": weightController.text,
                    "reps": repsController.text,
                    "sets": setsController.text,
                    "notes": notesController.text,
                    "date": formattedDate
                  };

                  var originalData =
                      widget.initialData; // 원래 데이터는 위젯의 초기 데이터로부터 가져옵니다.

                  // 데이터베이스에 운동 기록 추가
                  await updateExercise(updateData, originalData!);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, updateData);
                },
                child: const Text('변경하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
