import 'package:flutter/material.dart';
import 'database.dart';

class ExerciseDetailView extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseDetailView({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _ExerciseDetailViewState createState() => _ExerciseDetailViewState();
}

class _ExerciseDetailViewState extends State<ExerciseDetailView> {
  List<Map<String, dynamic>> exerciseData = [];
  List<Map<String, dynamic>> actualExerciseData = [];

  @override
  void initState() {
    super.initState();
    fetchExerciseDataForDate(widget.selectedDate).then((data) {
      setState(() {
        exerciseData = data;
      });

      // exercise_ids를 ','로 분리하여 정수 배열로 변환
      List<int> exerciseIds = exerciseData[0]["exercise_ids"]
          .split(',')
          .map<int>((e) => int.parse(e))
          .toList();

      // 이 ID를 사용하여 실제 운동 정보를 불러옴
      fetchExercisesByIds(exerciseIds).then((exerciseInfo) {
        // 이제 exerciseInfo에는 실제 운동 정보가 있을 것입니다.
        // 이 정보를 화면에 표시하도록 setState를 호출합니다.
        setState(() {
          actualExerciseData = exerciseInfo;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일"),
        ),
        body: exerciseData.isEmpty
            ? const Center(
                child: Text("기록된 운동이 없습니다."),
              )
            : ListView.builder(
                itemCount: actualExerciseData.length,
                itemBuilder: (context, index) {
                  var exerciseData = actualExerciseData[index];
                  double screenWidth = MediaQuery.of(context).size.width;
                  return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        child: Card(
                          color: Colors.blue,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //! 좌측 부분
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${exerciseData['weight']}kg',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${exerciseData['sets']}세트',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${exerciseData['reps']}회',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              ));
  }
}
