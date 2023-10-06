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

  @override
  void initState() {
    super.initState();
    fetchExerciseDataForDate(widget.selectedDate).then((data) {
      setState(() {
        exerciseData = data;
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
                itemCount: exerciseData.length,
                itemBuilder: (context, index) {
                  // 이 부분에서 각 운동의 정보를 표시하는 로직을 구현합니다.
                  String? exerciseName = exerciseData[index]["exerciseName"];
                  return ListTile(
                    title: Text(exerciseName ?? "Unknown"), // null 체크를 추가
                    // 여기에 더 많은 정보를 추가할 수 있습니다.
                  );
                },
              ));
  }
}
