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

      print(
          "Type of exerciseData[0]['exercise_ids']: ${exerciseData[0]['exercise_ids'].runtimeType}");
      print(
          "Value of exerciseData[0]['exercise_ids']: ${exerciseData[0]['exercise_ids']}");

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
                  return ListTile(
                    title: Text(actualExerciseData[index]["name"]),
                    subtitle:
                        Text("Weight: ${actualExerciseData[index]["weight"]}"),
                    // 여기에 더 많은 정보를 추가할 수 있습니다.
                  );
                },
              ));
  }
}
