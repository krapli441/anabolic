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
  List<Map<String, String>> exerciseDataList = [];

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
                              builder: (context) => const ExerciseRecord(),
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
                        onTap: () async {
                          
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
                                            '${exerciseData['exercise']}',
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
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // '운동 종료' 버튼이 눌렸을 때의 동작
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50), // 버튼의 너비와 높이 설정
            // 다른 스타일 설정도 가능
          ),
          child: const Text('운동 종료'),
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
                onPressed: () {
                  var exerciseData = {
                    "exercise": exerciseController.text,
                    "weight": weightController.text,
                    "reps": repsController.text,
                    "sets": setsController.text,
                    "notes": notesController.text
                  };
                  Navigator.pop(context, exerciseData);
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



                    // children: exerciseDataList.map((exerciseData) {
                    //   return SizedBox(
                    //       width: width + 10,
                    //       child: Card(
                    //           color: Colors.blue,
                    //           margin:
                    //               const EdgeInsets.only(top: 10, bottom: 10),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 //! 좌측 부분
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(
                    //                       '${exerciseData['exercise']}',
                    //                       style: const TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.white,
                    //                         fontSize: 20,
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       children: [
                    //                         const Icon(
                    //                           Icons.library_books,
                    //                           color: Colors.white,
                    //                           size: 20,
                    //                         ),
                    //                         const SizedBox(width: 5),
                    //                         Text(
                    //                           '${exerciseData['notes']}',
                    //                           style: const TextStyle(
                    //                               color: Colors.white),
                    //                         ),
                    //                       ],
                    //                     )
                    //                   ],
                    //                 ),
                    //                 //! 우측 부분
                    //                 Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.end,
                    //                   children: [
                    //                     Text(
                    //                       '${exerciseData['weight']}kg',
                    //                       style: const TextStyle(
                    //                           color: Colors.white),
                    //                     ),
                    //                     Text(
                    //                       '${exerciseData['sets']}세트',
                    //                       style: const TextStyle(
                    //                           color: Colors.white),
                    //                     ),
                    //                     Text(
                    //                       '${exerciseData['reps']}회',
                    //                       style: const TextStyle(
                    //                           color: Colors.white),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           )));
                    // }).toList(),